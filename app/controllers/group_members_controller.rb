class GroupMembersController < ApplicationController
  before_action :set_group_member, only: %i[ show edit update destroy ]

  # GET /group_members or /group_members.json
  def index
    @group = Group.find(params[:group_id])
    @group_members = @group.group_members
  end

  # GET /group_members/1 or /group_members/1.json
  def show
  end

  # GET /group_members/new
  def new
    @group = Group.find(params[:group_id])
  end

  # GET /group_members/1/edit
  def edit
  end

  # POST /group_members or /group_members.json
  def create
    @group = Group.find(params[:group_id])
    add_group_members

    respond_to do |format|
      begin
        if @group.save
          format.html { redirect_to @group, notice: "New members successfully added." }
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

  # PATCH/PUT /group_members/1 or /group_members/1.json
  def update
    respond_to do |format|
      if @group_member.update(group_member_params)
        format.html { redirect_to @group_member, notice: "Group member was successfully updated." }
        format.json { render :show, status: :ok, location: @group_member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_members/1 or /group_members/1.json
  def destroy
    # delete_channel_subscriptions
    @group_member.destroy
    respond_to do |format|
      format.html { redirect_to group_group_members_url(@group_member.group), notice: "#{@group_member.profile.full_name} was successfully removed from group." }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_group_member
    @group_member = GroupMember.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_member_params
    params.require(:group_member).permit(:profile_id, :group_id, :role)
  end

  def add_group_members
    profile_ids = params[:profile_select][:profile_id_list]
    profile_ids.each do |profile_id|
      profile_id = profile_id.to_i
      @group.group_members.build(profile_id: profile_id, role: 'member') unless group_member_exists?(profile_id)
    end
  end

  def group_member_exists?(profile_id)
    @group.group_members.find_by(profile_id: profile_id)
  end
end
