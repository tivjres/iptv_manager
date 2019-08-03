class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]

  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.all
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end

  def attach_lists
    # TODO mode this logic to 2 other method `prepare_channels` && `create_channels`
    @result = { success: false, all: 0, new: 0, files: params[:iptv_lists]&.size }
    params[:iptv_lists]&.each do |file|
      channel = { name: nil, group: nil, url: nil }
      File.read(file.path).split("\n").each do |line|
        if line.start_with?('#EXTINF')
          channel[:name] = line
        elsif line.start_with?('#EXTGRP')
          channel[:group] = line
        elsif line.start_with?('http')
          channel[:url] = line
        end
        if channel[:name].present? && channel[:group].present? && channel[:url].present?
          @result[:all] += 1
          Channel.find_or_create_by(url: channel[:url]) do |ch|
            @result[:new] += 1
            ch.status = 0
            ch.name = channel[:name]
            ch.group = Group.find_or_create_by(name: channel[:group])
            channel = { name: nil, group: nil, url: nil }
          end
        end
      end
      @result[:success] = true
    end
    @channels = Channel.all
    render :index
  end

  def list
    respond_to do |format|
      format.m3u
    end
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, notice: 'Channel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_channel
    @channel = Channel.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def channel_params
    params.require(:channel).permit(:url, :name, :status)
  end
end
