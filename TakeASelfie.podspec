Pod::Spec.new do |s|

    s.name                  = 'TakeASelfie'
    s.version               = '0.1.3'
    s.summary               = 'An iOS framework that uses the front camera, detects your face and takes a selfie.'
    s.homepage              = 'https://github.com/abdullahselek/TakeASelfie'
    s.license               = {
        :type => 'MIT',
        :file => 'LICENSE'
    }
    s.author                = {
        'Abdullah Selek' => 'abdullahselek@gmail.com'
    }
    s.source                = {
        :git => 'https://github.com/abdullahselek/TakeASelfie.git',
        :tag => s.version.to_s
    }
    s.ios.deployment_target = '11.0'
    s.source_files          = 'TakeASelfie/*.{h,m,swift}'
    s.requires_arc          = true
    s.swift_version         = '5.0'

end
