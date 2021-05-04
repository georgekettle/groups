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
          format.html { redirect_to channel_path(@channel), notice: "Members successfully added." }
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

  def destroy
    @channel_member = ChannelMember.find(params[:id])
    @channel_member.destroy
    respond_to do |format|
      format.html { redirect_to channel_channel_members_url(@channel_member.channel), notice: "#{@channel_member.profile.full_name} successfully removed from channel." }
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
