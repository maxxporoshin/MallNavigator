import UIKit

class NewNameViewController : UIViewController, UITextFieldDelegate {
    
    var delegate: NewNameViewControllerDelegate!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    var labelText: String?
    var textFieldText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        if labelText != nil {
            label.text = labelText
        }
        textField.becomeFirstResponder()
        if textFieldText != nil {
            textField.text = textFieldText
        }
    }
    
    //MARK: Actions
    @IBAction func save(sender: UIBarButtonItem) {
        delegate.newName(textField.text)
        textField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITextFieldDeleagte
    func textFieldDidBeginEditing(textField: UITextField) {
        if !textField.text!.isEmpty {
            textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol NewNameViewControllerDelegate {
    func newName(name: String?)
}
