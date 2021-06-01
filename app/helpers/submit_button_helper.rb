module SubmitButtonHelper
  def submit_with_loader(form, text = nil)
    text ||= form.object.new_record? ? "Create #{form.object.class}" : "Update #{form.object.class}"
    button_tag(type: 'submit', data: {controller: 'loader', action:'click->loader#showLoader', loader_classes_value:'text-white w-4 h-4', disable: true }) do
      text.capitalize
    end
  end
end
