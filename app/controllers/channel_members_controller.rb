class ChannelMembersController < ApplicationController

  def index
    @channel = Channel.find(params[:channel_id])
    @channel_members = @channel.channel_members
  end

  def new
    @channel = Channel.find(params[:channel_id])
  end

  def create
    @channel = Channel.find(params[:channel_id])
    add_channel_members

    respond_to do |format|
      begin
        if @channel.save
          format.html { redirect_to channel_path(@channel), notice: "Channel was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        @channel.errors.add(:base, "cannot add the same person twice")
        @channel.errors.add(:base, "please do NOT add yourself... as you will automatically be added")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def add_channel_members
    profile_ids = params[:profile_select][:profile_id_list]
    profile_ids.each do |profile_id|
      profile_id = profile_id.to_i
      @channel.channel_members.build(profile_id: profile_id, role: 'member') unless channel_member_exists?(profile_id)
    end
  end

  def channel_member_exists?(profile_id)
    @channel.channel_members.find_by(profile_id: profile_id)
  end
end
