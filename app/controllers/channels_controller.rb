class ChannelsController < ApplicationController
  before_action :set_channel, only: %i[ show edit update destroy ]
  layout 'no_navbar', except: [:all]

  # GET /channels or /channels.json
  def index
    @group = Group.find(params[:group_id])
    @channel_members = @group.channel_members.where(profile: current_user.profile)
  end

  def all
    # actually return all channel_members and display channel from each
    # this way we can check channel_member.muted?
    query = "SELECT channel_members.* FROM channel_members
                INNER JOIN channels ON channels.id = channel_members.channel_id
                INNER JOIN profiles ON profiles.id = channel_members.profile_id
                INNER JOIN messages ON channels.id = messages.channel_id
                WHERE profiles.id = #{current_user.profile.id}
                GROUP BY channel_members.id
                ORDER BY MAX(messages.created_at) DESC"
    with_messages = ChannelMember.find_by_sql(query)
    without_messages = current_user.profile.channel_members.left_outer_joins(channel: :messages).where(messages: { id: nil })

    @channel_members = (with_messages + without_messages).uniq
  end

  # GET /channels/1 or /channels/1.json
  def show
    mark_channel_messages_as_read
    @message = Message.new
    @back_link = set_back_link
  end

  # GET /channels/new
  def new
    @group = Group.find(params[:group_id])
    @channel = @group.channels.new
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels or /channels.json
  def create
    @channel = Channel.new(channel_params)
    @group = Group.find(params[:group_id])
    @channel.group = @group
    add_channel_members
    add_current_user_as_owner # add current_user as channel_member

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

  # PATCH/PUT /channels/1 or /channels/1.json
  def update
    respond_to do |format|
      begin
        if @channel.update(channel_params)
          format.html { redirect_to @channel, notice: "Channel was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        @channel.errors.add(:base, "cannot add the same person twice")
        @channel.errors.add(:base, "please do NOT add yourself... as you will automatically be added")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1 or /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to group_url(@channel.group), notice: "Channel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # header back link depends on active tab
    def set_back_link
      case session[:navigation]
      when 'groups'
        return group_path(@channel.group)
      when 'notifications'
        return notifications_path
      else
        return all_channels_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:name)
    end

    def add_current_user_as_owner
      @channel.channel_members.build(profile_id: current_user.profile.id, role: 'owner')
    end

    def add_channel_members
      profile_ids = params[:profile_select][:profile_id_list]
      profile_ids.each do |profile_id|
        profile_id = profile_id.to_i
        @channel.channel_members.build(profile_id: profile_id, role: 'member') unless profile_id == current_user.profile.id
      end
    end

    def mark_channel_messages_as_read
      # channel_member.update(messages_checked: true)
      notifications = Notification.where(read_at: nil, type: 'MessageNotification', recipient: current_user.profile).select{|n| n.params[:message].channel == @channel}
      notifications.each do |n|
        n.mark_as_read!
      end
    end
end
