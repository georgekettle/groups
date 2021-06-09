class MessagesController < ApplicationController
  before_action :set_message, only: %i[ update destroy ]

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)
    @channel = Channel.find(params[:channel_id])
    @message.channel = @channel
    @message.profile = current_user.profile

    respond_to do |format|
      if @message.save
        # format.turbo_stream here :) (render from turbo template)
        format.html { redirect_to channel_path(@channel) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@message, partial: 'messages/form', locals: { message: @message, channel: @channel })}
        format.html { render 'channels/show', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content)
    end
end
