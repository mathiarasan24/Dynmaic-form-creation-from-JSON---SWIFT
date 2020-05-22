# Dynmaic-form-creation-from-JSON---SWIFT
Creating a registration form using sample JSON input value.

Create a framework which can render a form with multiple pages from a json configuration.
The form can contain upto 3 pages and should support text field, select box and checkbox group.
When the next button is clicked, all the fields in the page should be validated. If there are any empty.
If not, user should be taken to the next page. When submit is clicked, the value of all the form fields should be collected as a key value pair and sent to the service for processing.

Usage details:

JSON-Parsing
Dynamicly creating constraint using constraintsWithVisualFormat
  class func constraints(withVisualFormat format: String, 
               options opts: NSLayoutConstraint.FormatOptions = [], 
               metrics: [String : Any]?, 
                 views: [String : Any]) -> [NSLayoutConstraint]
As usual constraint with anchor
All single UIView and UIViewController
View initialization extenstions
