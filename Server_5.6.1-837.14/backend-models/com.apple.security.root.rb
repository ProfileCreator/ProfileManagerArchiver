#-------------------------------------------------------------------------
# Copyright (c) 2018 Apple Inc. All rights reserved.
#
# IMPORTANT NOTE: This file is licensed only for use on Apple-branded
# computers and is subject to the terms and conditions of the Apple Software
# License Agreement accompanying the package this file is a part of.
# You may not port this file to another platform without Apple's written consent.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
class CertificateKnobSet < KnobSet
#-------------------------------------------------------------------------

  before_save :before_save_cert_knob_set

  @@payload_types = {'root'   => 'com.apple.security.root',
                     'pkcs1'  => 'com.apple.security.pkcs1',
                     'pkcs12' => 'com.apple.security.pkcs12' }

  @@type_map = {'com.apple.security.root'   => 'root',
                'com.apple.security.pkcs1'  => 'pkcs1',
                'com.apple.security.pkcs12' => 'pkcs12' }

  @@payload_subidentifier = 'certificate'
  @@is_unique             = false
  @@payload_name          = 'Certificate'

  #-------------------------------------------------------------------------

  def self.payload_type;    return @@payload_types['pkcs1'];  end

  #-------------------------------------------------------------------------

  # This is a user specified parameter, it cannot be localized (but the base class does this for us)
  # Except for short display name, we can provide
  def localized_payload_display_name(short = false);  return (short ? I18n.t('certificate_display_name') : self.settings_name);     end
  def payload_type;                                   return @@payload_types[(self.internal_use_flag_certificate_type || 'pkcs1')]; end
  def attributes;                                     super.merge({'PayloadContent' => self.PayloadContent});                       end
  def payload_type=(type);                            self.internal_use_flag_certificate_type = @@type_map[type];                   end

  #-------------------------------------------------------------------------

  def PayloadContent
    df = self.data_file
    return BinaryData.new((df && df.read_as_base64) || '')
  end # PayloadContent

  #-------------------------------------------------------------------------

  def delete
    df = self.data_file
    df.delete if df
    super
  end # delete

  #-------------------------------------------------------------------------

  def before_save_cert_knob_set
    data_file = self.data_file
    return true unless data_file

    meta = data_file.metadata
    # The file metadata is a hash with keys as string
    unless meta && meta['cert_data'] && meta['cert_data']['certificate']
      DataFileHelper.parse_cert(data_file.id)
      meta = data_file.metadata
    end

    if meta && meta['cert_data']
      if meta['cert_data']['is_identity']
        self.payload_type = 'com.apple.security.pkcs12'
      elsif meta['cert_data']['is_root']
        self.payload_type = 'com.apple.security.root'
      else
        self.payload_type = 'com.apple.security.pkcs1'
      end
    end
    return true
  end # before_save_cert_knob_set

  #-------------------------------------------------------------------------

  def modify_attributes(attr_hash, extended = false)
    df = self.data_file
    attr_hash['data_files'] = [df.id] if df
    return attr_hash
  end # modify_attributes

#-------------------------------------------------------------------------
end # class CertificateKnobSet
#-------------------------------------------------------------------------
