Pod::Spec.new do |s|
  s.name         = "APLWhatsappProxyActivity"
  s.version      = "0.0.1"
  s.summary      = "A UIActivity to support sharing via whatsapp."

  s.description  = <<-DESC
                    Apple's UIActivityViewController does not display a Whatsapp Button.
                    We add a custom application activity here, to display a Whatsapp Button in this case.
                    Our activity composes a message text from the given activity items and opens the whatsapp app if it's installed
                    on the device.
                   DESC

  s.homepage     = "https://github.com/apploft/APLWhatsappProxyActivity"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author       = 'Christopher Gross'

  s.platform     = :ios, '5.0'

  s.source       = { :git => "https://github.com/apploft/APLWhatsappProxyActivity.git", :tag => s.version.to_s }

  s.source_files  = 'APLWhatsappProxyActivity', '*.{h,m}'
  s.resources  = ['*.png']

  s.frameworks  = 'Social'
  s.requires_arc = true

end