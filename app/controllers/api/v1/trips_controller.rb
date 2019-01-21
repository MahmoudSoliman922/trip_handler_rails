class Api::V1::TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy]

  # GET /trips
  def index
    @trips = Trip.all
    # caching handling
    render json: @trips if stale?(@trip)
  end

  # GET /trips/1
  def show
    # caching handling
    render json: @trip if stale?(@trip)
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      render json: @trip, status: :created
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trips/1
  def update
    # status array is represented with order to check the status direction
    status = ['waiting','ongoing','completed']
    coming_status = trip_params["status"]
    updating_trip = Trip.find(params["id"])
    # first check if the coming status is valid or not
    if status.index(coming_status.downcase()) == nil
      render json: {msg: "invalid status."}, status: :unprocessable_entity
    # second check if its on the right direction
    elsif status.index(coming_status.downcase()) < status.index(updating_trip.status.downcase())
      render json: {msg: " status can be only changed in one direction. "}, status: :unprocessable_entity
    # third if it's at least the same status then it'll update otherwise it will not
    elsif status.index(coming_status.downcase()) >= status.index(updating_trip.status.downcase())
        if @trip.update(trip_params)
          render json: @trip
        else
          render json: @trip.errors, status: :unprocessable_entity
        end
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trip_params
      params.require(:trip).permit(:from, :to, :status)
    end
end
