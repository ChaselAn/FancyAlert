FancyAlert

* A more fancy alert
* You can use it like UIAlert

### Requirements

* Swift 4.1, iOS 9

###  Installation

* With Cocoapods:

```ruby
pod 'FancyAlert', '~> 1.4.1'
# Then, run the following command:
$ pod install
```

### Example

* Normal Alert

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/normal_alert.png"/>

* Alert with TextField

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/alert_with_textfield.png"/>

- Alert with more TextFields

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/alert_with_textfields.png"/>

* Alert with TextView

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/alert_with_textview.png"/>

* Alert with Progress

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/alert_with_progress.gif"/>

* ActionSheet

<img width="250" height="445" src="https://raw.githubusercontent.com/ChaselAn/FancyAlert/master/actionsheet.png"/>

### How to use

```swift
let firstAction = FancyAlertAction(title: "第一个", style: .normal, handler: {
            print("第一个action")
        })
let alertViewController = FancyAlertViewController(style: .alert, title: "大标题大标题大标题大标题大标题大标题大标题大标题大标题", message: "小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题小标题", actions: [firstAction])
let cancelAction = FancyAlertAction(title: "取消", style: .cancel, handler: {
            print("取消action")
        })
alertViewController.addAction(cancelAction)
alertVC.addTextField { (textField) in
                textField.placeholder = "请输入用户名"
                textField.style = .gray
                textField.maxInputLength = 10
            } // add textField
alertVC.addTextView { (textView) in
                textView.maxInputLength = 50
            } // add textView
alertViewController.hasProgress = true // have progress
alertViewController.progress = 0.5 // progress value
present(alertViewController, animated: true, completion: nil)
```

