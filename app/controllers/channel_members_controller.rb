class ChannelMembersController < ApplicationController
  before_action :set_channel_member, only: %i[ show edit update destroy ]
  layout 'no_navbar'
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    @channel = Channel.find(params[:channel_id])
    @channel_members = policy_scope(@channel.channel_members)
  end

  def new
    @channel = Channel.find(params[:channel_id])
    authorize @channel, policy_class: ChannelMemberPolicy
  end

  def create
    @channel = Channel.find(params[:channel_id])
    authorize @channel, policy_class: ChannelMemberPolicy
    add_channel_members

    respond_to do |format|
      begin
        if @channel.save
          format.html { redirect_back fallback_location: channel_path(@channel), notice: "Members successfully added." }
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

  def update
    @channel = @channel_member.channel
    respond_to do |format|
      if @channel_member.update(channel_member_params)
        format.html { redirect_to @channel, notice: "##{@channel.name} channel preferences updated." }
      else
        format.html { render @channel, status: :unprocessable_entity, alert: "Something went wrong..." }
      end
    end
  end

  def destroy
    @channel_member.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: group_url(@channel_member.channel.group), notice: "#{@channel_member.profile.full_name} has been removed from ##{@channel_member.channel.name}." }
    end
  end

  def search
    @channel = Channel.find(params[:channel_id])
    group = @channel.group
    if params[:q]
      @profiles = group.profiles.global_search(params[:q])
    else
      @profiles = group.profiles.all
    end
    render('profiles/search') # we only use this for search field (which requires json)
  end

  private

  def set_channel_member
    @channel_member = ChannelMember.find(params[:id])
    authorize @channel_member
  end

  def add_channel_members
    profile_ids = params[:profile_select][:profile_id_list]
    profile_ids.each do |profile_id|
      profile_id = profile_id.to_i
      @channel.channel_members.build(profile_id: profile_id, role: 'member') unless channel_member_exists?(profile_id)
    end
  end

  def channel_member_params
    params.require(:channel_member).permit(:muted)
  end

  def channel_member_exists?(profile_id)
    @channel.channel_members.find_by(profile_id: profile_id)
  end
end
