class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  skip_after_action :verify_policy_scoped, only: [:index]

  # GET /groups or /groups.json
  def index
    @group_members = current_user.profile.group_members
  end

  # GET /groups/1 or /groups/1.json
  def show
    @primary_channel_members = ChannelMember.where(channel: @group.primary_channels, profile: current_user.profile)
    @subscribed_channel_members = set_subscribed_channel_members
    set_group_member # that belongs to current_user
    set_header_options
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    add_group_members
    @group.group_members.build(profile_id: current_user.profile.id, role: 'owner')
    authorize @group

    respond_to do |format|
      begin
        if @group.save
          format.html { redirect_to @group, notice: "Group was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        @group.errors.add(:base, "cannot add the same person twice")
        @group.errors.add(:base, "please do NOT add yourself... as you will automatically be added")
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      begin
        if @group.update(group_params)
          format.html { redirect_to @group, notice: "Group was successfully updated." }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      rescue ActiveRecord::RecordNotUnique
        @group.errors.add(:base, "cannot add the same person twice")
        @group.errors.add(:base, "please do NOT add yourself... as you will automatically be added")
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_group_member
    @group_member = @group.group_members.find_by(profile: current_user.profile)
  end

  def set_header_options
    if @group_member && policy(@group).update?
      @header_options = {
      title: "#{@group.name}",
      links: [
          {text: 'View group members', path: group_group_members_path(@group)},
          {text: 'Edit group', path: edit_group_path(@group)},
          {text: 'Leave group', path: group_member_path(@group_member), method: :delete}
        ]}
    else
      @header_options = {
        title: "#{@group.name}",
        links: [
            {text: 'View group members', path: group_group_members_path(@group)}
          ]}
    end
  end

  def set_subscribed_channel_members
    user_channel_members = @group.channel_members.where(profile: current_user.profile).where.not(channel: @group.primary_channels)
    with_messages = user_channel_members.joins(:messages).order("messages.created_at desc").uniq
    without_messages = user_channel_members.where.not(id: with_messages, channel: @group.primary_channels)
    with_messages + without_messages
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name)
  end

  def add_group_members
    profile_ids = params[:profile_select][:profile_id_list]
    profile_ids.each do |profile_id|
      profile_id = profile_id.to_i
      @group.group_members.build(profile_id: profile_id, role: 'member') unless profile_id == current_user.profile.id
    end
  end
end
