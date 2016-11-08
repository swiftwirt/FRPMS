import UIKit
class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var greetingsTextField, nameTextField: UITextField!
    @IBOutlet var greetingButtons: [UIButton]!
    var selectedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingsTextField.delegate = self
        nameTextField.delegate = self
        greetingsTextField.isEnabled = false
        selectedButton = greetingButtons[0]
        greetingsLabel.text = (selectedButton.titleLabel?.text)! + " " + nameTextField.text!
    }
    @IBAction func stateChanged(_ sender: UISegmentedControl) {
        if stateSegmentedControl.selectedSegmentIndex == 1 {
            for button in greetingButtons{button.isEnabled = false}
            greetingsTextField.isEnabled = true
            greetingsLabel.text = greetingsTextField.text! + " " + nameTextField.text!
        }else{
            greetingsTextField.isEnabled = false
            for button in greetingButtons{ button.isEnabled = true}
            greetingsLabel.text = (selectedButton.titleLabel?.text!)! + " " + nameTextField.text!
        }
    }
    @IBAction func greetingsButtonPressed(_ sender: UIButton) {
        if stateSegmentedControl.selectedSegmentIndex == 0{
            greetingsLabel.text = (sender.titleLabel?.text)! + " " + nameTextField.text!
            selectedButton = sender
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var contents = textField.text
        if string == "" {contents?.remove(at: (contents?.index(before: (contents?.endIndex)!))!)}
        if stateSegmentedControl.selectedSegmentIndex == 1 && textField == greetingsTextField{
            greetingsLabel.text = contents! + string + " " + nameTextField.text!
        }else if stateSegmentedControl.selectedSegmentIndex == 1 && textField == nameTextField{
            greetingsLabel.text = greetingsTextField.text! + " " + contents! + string
        }else if stateSegmentedControl.selectedSegmentIndex == 0 && textField == nameTextField{
            greetingsLabel.text = (selectedButton.titleLabel?.text)! + " " + contents! + string
        }
        return true
    }
}
