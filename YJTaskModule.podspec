
Pod::Spec.new do |s|
  s.name             = 'YJTaskModule'
  s.version          = '1.1.5'
  s.summary          = '作业库'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LYajun/YJTaskModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LYajun' => 'liuyajun1999@icloud.com' }
  s.source           = { :git => 'https://github.com/LYajun/YJTaskModule.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.resources = 'YJTaskModule/Classes/YJTaskModule.bundle'

  s.subspec 'Const' do |const|
      const.source_files = 'YJTaskModule/Classes/Const/**/*'
      const.dependency 'YJExtensions'
  end
  
  s.subspec 'AlertView' do |alertView|
        alertView.source_files = 'YJTaskModule/Classes/AlertView/**/*'
        alertView.dependency 'YJTaskModule/Const'
        alertView.dependency 'Masonry'
    end

  
  
    s.subspec 'Base' do |base|
        base.source_files = 'YJTaskModule/Classes/Base/**/*'
        base.dependency 'MJExtension'
        base.dependency 'YJTaskModule/Const'
        base.dependency 'BlocksKit'
        base.dependency 'LGAlertHUD'
    end

    s.subspec 'AnswerEditView' do |answerEditView|
        answerEditView.source_files = 'YJTaskModule/Classes/AnswerEditView/**/*'
        answerEditView.dependency 'YJTaskModule/Base'
        answerEditView.dependency 'YJTaskModule/Const'

        answerEditView.dependency 'Masonry'
        answerEditView.dependency 'TFHpple'
        answerEditView.dependency 'YJResizableSplitView'
        answerEditView.dependency 'LGAlertHUD'
    end

    s.subspec 'YJFileManager' do |fileManager|
        fileManager.source_files = 'YJTaskModule/Classes/YJFileManager/**/*'

    end

    s.subspec 'Model' do |model|
        model.source_files = 'YJTaskModule/Classes/Model/**/*'
        model.dependency 'YJTaskModule/Base'
        model.dependency 'YJTaskModule/YJFileManager'
        model.dependency 'YJTaskModule/Const'
        model.dependency 'TFHpple'
        model.dependency 'MJExtension'
        model.dependency 'YJNetManager'
        model.dependency 'YJTaskMark'
    end

    s.subspec 'TitleView' do |titleView|
        titleView.source_files = 'YJTaskModule/Classes/TitleView/**/*'
        titleView.dependency 'YJTaskModule/Const'
        titleView.dependency 'Masonry'
    end

    s.subspec 'BaseItem' do |baseItem|
        baseItem.source_files = 'YJTaskModule/Classes/BaseItem/**/*'
        baseItem.dependency 'YJTaskModule/Model'
        baseItem.dependency 'YJTaskModule/TitleView'
        baseItem.dependency 'YJTaskModule/Const'
        baseItem.dependency 'Masonry'
    end

    s.subspec 'ImageLabel' do |imageLabel|
        imageLabel.source_files = 'YJTaskModule/Classes/ImageLabel/**/*'
        imageLabel.dependency 'YJTaskModule/Const'
        imageLabel.dependency 'Masonry'
    end

    s.subspec 'MatchView' do |matchView|
        matchView.source_files = 'YJTaskModule/Classes/MatchView/**/*'
        matchView.dependency 'YJTaskModule/Base'
        matchView.dependency 'YJTaskModule/ImageLabel'
        matchView.dependency 'YJTaskModule/Const'
        matchView.dependency 'Masonry'
    end

    s.subspec 'YJCorrect' do |correct|
        correct.source_files = 'YJTaskModule/Classes/YJCorrect/**/*'
        correct.dependency 'YJTaskModule/Base'
        correct.dependency 'YJTaskModule/Model'
        correct.dependency 'YJTaskModule/Const'
        correct.dependency 'Masonry'
        correct.dependency 'LGAlertHUD'
    end

    s.subspec 'YJSpeechMarkView' do |speechMarkView|
        speechMarkView.source_files = 'YJTaskModule/Classes/YJSpeechMarkView/**/*'
        speechMarkView.dependency 'YJTaskModule/Const'

        speechMarkView.dependency 'Masonry'
    end

    s.subspec 'Cell' do |cell|
        cell.source_files = 'YJTaskModule/Classes/Cell/**/*'
        cell.dependency 'YJTaskModule/Base'
        cell.dependency 'YJTaskModule/Model'
        cell.dependency 'YJTaskModule/Const'
        cell.dependency 'YJTaskModule/YJSpeechMarkView'
        cell.dependency 'YJTaskModule/ImageLabel'

        cell.dependency 'YJTaskMark'
        cell.dependency 'TFHpple'
        cell.dependency 'Masonry'
        cell.dependency 'LGTalk'
        cell.dependency 'YJNetManager'
        cell.dependency 'LGAlertHUD'
        cell.dependency 'SDWebImage'
    end

    s.subspec 'YJProgressView' do |progressView|
        progressView.source_files = 'YJTaskModule/Classes/YJProgressView/**/*'
    end


    s.subspec 'ActivityIndicatorView' do |activityIndicatorView|
        activityIndicatorView.source_files = 'YJTaskModule/Classes/ActivityIndicatorView/**/*'
    end

    s.subspec 'ListenPlayer' do |listenPlayer|
        listenPlayer.source_files = 'YJTaskModule/Classes/ListenPlayer/**/*'
        listenPlayer.dependency 'YJTaskModule/Base'
        listenPlayer.dependency 'YJTaskModule/YJProgressView'
        listenPlayer.dependency 'YJTaskModule/Const'

        listenPlayer.dependency 'Masonry'
        listenPlayer.dependency 'LGAlertHUD'
        listenPlayer.dependency 'YJSearchController'
    end

    s.subspec 'TopicView' do |topicView|
        topicView.source_files = 'YJTaskModule/Classes/TopicView/**/*'
        topicView.dependency 'YJTaskModule/Model'
        topicView.dependency 'YJTaskModule/MatchView'
        topicView.dependency 'YJTaskModule/Const'
        topicView.dependency 'YJTaskModule/ListenPlayer'
        topicView.dependency 'YJTaskModule/ActivityIndicatorView'
        topicView.dependency 'YJTaskModule/YJCorrect'

        topicView.dependency 'TFHpple'
        topicView.dependency 'Masonry'
        topicView.dependency 'YJSearchController'
    end

    s.subspec 'TopicCardView' do |topicCardView|
        topicCardView.source_files = 'YJTaskModule/Classes/TopicCardView/**/*'
        topicCardView.dependency 'YJTaskModule/ImageLabel'

        topicCardView.dependency 'YJTaskModule/Const'
        topicCardView.dependency 'Masonry'
    end

    s.subspec 'TaskItem' do |taskItem|
        taskItem.source_files = 'YJTaskModule/Classes/TaskItem/**/*'
        taskItem.dependency 'YJTaskModule/Model'
        taskItem.dependency 'YJTaskModule/Const'
        taskItem.dependency 'YJTaskModule/TopicView'
        taskItem.dependency 'YJTaskModule/BaseItem'
        taskItem.dependency 'YJTaskModule/AnswerEditView'
        taskItem.dependency 'YJTaskModule/Cell'
        taskItem.dependency 'YJTaskModule/TitleView'

        taskItem.dependency 'SwipeView'
        taskItem.dependency 'YJResizableSplitView'
        taskItem.dependency 'Masonry'
    end

end
