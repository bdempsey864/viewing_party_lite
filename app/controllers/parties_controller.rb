# frozen_string_literal: true

class PartiesController < ApplicationController
  def new
    @users = User.all
    @user = User.find(params[:user_id])
    @movie = MovieFacade.get_movie(params[:movie_id])
  end

  def create
    @host = User.find(session[:user_id])
    @party = Party.create!(
      start_date: "#{params['start_date(1i)']}-#{params['start_date(2i)']}-#{params['start_date(3i)']}",
      start_time: "#{params['start_time(4i)']}:#{params['start_time(5i)']}",
      duration: params["duration"],
      movie_id: params["id"],
      host_id: @host.id
    )
    UserParty.create!(user_id: @host.id, party_id: @party.id)
    params[:invitations].drop(1).each do |user_id|
      if user_id.to_i != @host.id
        UserParty.create!(user_id: user_id, party_id: @party.id)
      end
    end
    redirect_to "/users/#{@user.id}"
  end
end
