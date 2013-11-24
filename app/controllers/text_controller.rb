class TextController < ApplicationController
  protect_from_forgery except: :incoming

  def incoming

    phone = PhoneNumber.find_or_create_by(:number => params["From"])
    @user = phone.user
    @seq = phone.response_sequences.last

    message = params["Body"]
    response_text = ""

    if message.match(/find/i) || phone.new_record? || @seq.nil?
      @seq = phone.response_sequences.new
    else
      new_sequence = false
    end

    if @seq.new_record?
      if @user.nil?
        @user = phone.create_user
        @user.save
        response_text = ask_for_verification
      elsif @user && !@user.verified?
        response_text = ask_for_verification
      else
        response_text = send_option_list
      end
    else
      @seq.incomings << message
      last_outbound = @seq.outgoings.last
      case
      when last_outbound.match(/What are you looking for/i)
        response_text = ask_for_location
      when last_outbound.match(/Where are you/i)
        last_incoming = @seq.incomings.last
        begin
          coordinates = Geocoder.coordinates(message)
          case
          when last_incoming.match(/wifi/i)
            #find wifi spot
            places = Place.wifi.near(coordinates)
            response_text = send_place_info(places)
          when last_incoming.match(/hang/i)
            #find hang spot
            places = Place.hang.near(coordinates)
            response_text = send_place_info(places)
          when last_incoming.match(/sleep/i)
            #find sleep spot
            places = Place.sleep.near(coordinates)
            response_text = send_place_info(places)
          else
            response_text = send_error_message
          end
        rescue StandardError => e
          logger.info "Exception took place: #{e}"
          response_text = send_error_message
        end
      when last_outbound.match(/You can hang/i)
        case message
        when 'y'
          send_directions
        when 'n'
          #send thanks
          response_text = "Something helpful here"
        else
          response_text = send_error_message
        end
      when last_outbound.match(/Do you have a verification code|Sorry, that code didn't work/i)
        #check for verification code here
        if @user.verify!(message)
          response_text = "Thanks! #{send_option_list}"
        else
          response_text = "Sorry, that code didn't work. Check spelling and capitalization and try again."
        end
      else
        response_text = send_error_message
      end
    end

    @seq.outgoings << response_text
    @seq.outgoings_will_change!
    @seq.incomings_will_change!
    @seq.save

    resp = Twilio::TwiML::Response.new do |r|
      r.Message response_text
    end

    render xml: resp.text
  end

  private

  def ask_for_location
    "Where are you? Say an address or intersection."
  end

  def ask_for_verification
    'Do you have a verification code? Enter it or visit the SF LGBT Center to get one.'
  end

  def send_option_list
    'What are you looking for? Say wifi, hang, sleep'
  end

  def send_directions

  end

  def send_error_message
    'Sorry, we had a hard time figuring out what you were saying. Please try again'
  end

  def send_place_info(places)
    if places && !places.first.nil?
      "You can hang here: #{places.first.name} at #{places.first.address}. Need directions? y/n"
    else
      send_error_message
    end
  end
end
