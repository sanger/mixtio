if Rails.configuration.stub_ldap

  Authentication::Ldap = Authentication::FakeLdap
end