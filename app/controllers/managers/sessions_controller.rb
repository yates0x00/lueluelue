class Managers::SessionsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :verify_signed_out_manager, only: :destroy
  prepend_before_action(only: [:create, :destroy]) { request.env["devise.skip_timeout"] = true }

  def new
    self.resource = resource_class.new(sign_in_params)
  end

  def create
    manager = Manager.where('email = ?', params[:manager][:email]).first
    if manager.blank?
      Rails.logger.info "-- case 1 用户名不存在"
      redirect_to root_path, alert: '用户名不存在。请立刻联系管理员。多次尝试失败会上报风控系统' and return
    end

    if manager.blank? || !manager.valid_password?(params[:manager][:password])
      Rails.logger.info "-- case 2 邮箱与密码不匹配？"
      redirect_to root_path, alert: '邮箱与密码不匹配' and return
    end

    if manager.valid_password? params[:manager][:password]
      sign_in manager
      flash[:success] = '登陆成功'
      redirect_to servers_path
    else
      Rails.logger.info "-- case 3 邮箱与密码不匹配？"
      redirect_to :back, alert: '邮箱与密码不匹配'
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def translation_scope
    'devise.sessions'
  end

  private

  def verify_signed_out_manager
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out
      respond_to_on_destroy
    end
  end

  def all_signed_out?
    managers = Devise.mappings.keys.map { |s| warden.manager(scope: s, run_callbacks: false) }
    managers.all?(&:blank?)
  end

  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end
