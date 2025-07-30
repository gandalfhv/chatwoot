class GlobalConfigService
  def self.load(config_key, default_value)
   # --- INICIO DE LA PERSONALIZACIÓN ---
    # Interceptamos las claves de configuración específicas y devolvemos nuestros valores.
    # Esto anula cualquier valor de la base de datos o de los archivos .yml.
    # case config_key
    # when 'BRAND_NAME'
    #   return 'MultiAgente MibOT'
    # when 'BRAND_URL'
    #   return 'https://prograpps.com/multiagente'
    # when 'WIDGET_BRAND_URL'
    #   return 'https://prograpps.com'
    # when 'TERMS_URL'
    #   return 'https://prograpps.com/terminos-servicio'
    # when 'PRIVACY_URL'
    #   return 'https://prograpps.com/politica-privacidad'
    # end
    # --- FIN DE LA PERSONALIZACIÓN ---
    config = GlobalConfig.get(config_key)[config_key]
    return config if config.present?

    # To support migrating existing instance relying on env variables
    # TODO: deprecate this later down the line
    config_value = ENV.fetch(config_key) { default_value }

    return if config_value.blank?

    i = InstallationConfig.where(name: config_key).first_or_create(value: config_value, locked: false)
    # To clear a nil value that might have been cached in the previous call
    GlobalConfig.clear_cache
    i.value
  end
end
