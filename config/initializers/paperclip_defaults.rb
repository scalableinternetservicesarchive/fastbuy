Paperclip::Attachment.default_options.update({
  path: ":rails_root/public/assets/images/:hash.:extension",
  url: "/assets/images/:hash.:extension",
  hash_secret: "longSecretKey",
  hash_data: ":rails_root/public/assets/images/"
})
