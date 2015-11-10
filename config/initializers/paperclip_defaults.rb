Paperclip::Attachment.default_options.update({
  url: "/assets/images/:hash.:extension",
  path: ":rails_root/public:url",
  hash_secret: "abfa04a42c94f58d17a509bccb2276d2f2e1718e23de5f0ff4bc93b4c922c2dbd23f81b31a7932fbf4424c95f14e055639d2376f8b3cb40ebf91ea4682197645"
})
