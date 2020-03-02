import UIKit

/// 汎用ダイアログ表示拡張
extension UIViewController {
    enum DialogResult {
        case ok
        case cancel
    }
    /// UIViewController.createConfirmDialogの実行結果コールバック
    typealias DialogResultFunc = (_ result: DialogResult) -> Void

    /// OK/キャンセルの２ボタンのダイアログを表示する。
    /// ボタンラベルはokLabel, cancelLabel で変更可能です。
    func showConfirmDialog(
        title: String? = nil, message: String,
        okLabel: String? = nil, cancelLabel: String? = nil,
        animated: Bool = true,
        callback: DialogResultFunc? = nil) {

        present(UIViewController.createConfirmDialog(
            title: title,
            message: message,
            okLabel: okLabel,
            cancelLabel: cancelLabel,
            callback: callback
        ), animated: animated)
    }

    /// OKボタンのみのアラート用ダイアログを表示する。
    /// ボタンラベルは okLabel で変更可能です。
    func showAlertDialog(
        title: String? = nil, message: String,
        okLabel: String? = nil,
        animated: Bool = true,
        callback: (() -> Void)? = nil) {

        present(UIViewController.createAlertDialog(
            title: title,
            message: message,
            okLabel: okLabel,
            callback: callback
        ), animated: animated)
    }

    /// 指定した任意のボタンを持つダイアログを表示する。
    func showCustomDialog(
        title: String? = nil,
        message: String,
        actions: [UIAlertAction],
        style: UIAlertController.Style = .alert, animated: Bool = true) {

        present(UIViewController.createCustomDialog(
            title: title,
            message: message,
            actions: actions,
            style: style
        ), animated: animated)
    }


    /// OK/キャンセルの２ボタンのダイアログを生成する。
    /// ボタンラベルはokLabel, cancelLabel で変更可能です。
    static func createConfirmDialog(
        title: String? = nil, message: String,
        okLabel: String? = nil, cancelLabel: String? = nil,
        animated: Bool = true,
        callback: DialogResultFunc? = nil) -> UIAlertController {

        return createCustomDialog(
            title: title,
            message: message,
            actions: [
                UIAlertAction(title: okLabel ?? "OK", style: .default) { _ in
                    callback?(.ok)
                },
                UIAlertAction(title: cancelLabel ?? "キャンセル", style: .cancel) { _ in
                    callback?(.cancel)
                }
            ])
    }

    /// OKボタンのみのアラート用ダイアログを生成する。
    /// ボタンラベルは okLabel で変更可能です。
    static func createAlertDialog(
        title: String? = nil, message: String,
        okLabel: String? = nil,
        animated: Bool = true,
        callback: (() -> Void)? = nil) -> UIAlertController {

        return createCustomDialog(
            title: title,
            message: message,
            actions: [
                UIAlertAction(title: okLabel ?? "OK", style: .default) { _ in
                    callback?()
                },
            ])
    }

    /// 指定した任意のボタンを持つダイアログを生成する。
    static func createCustomDialog(
        title: String? = nil,
        message: String,
        actions: [UIAlertAction],
        style: UIAlertController.Style = .alert, animated: Bool = true) -> UIAlertController {

        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: style)
        actions.forEach {
            alertController.addAction($0)
        }
        return alertController
    }

}
