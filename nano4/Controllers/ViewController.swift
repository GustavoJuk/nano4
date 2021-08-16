//
//  ViewController.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 12/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data: [Pastas]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchFolder()
    }
    
    func fetchFolder () {
        
        do{
            self.data = try context.fetch(Pastas.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Nova pasta", message: "Digite um nome para esta pasta", preferredStyle: .alert)
        alert.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel)
        let submitButton = UIAlertAction(title: "Salvar", style: .default) { (action) in
            
            let textfield = alert.textFields![0]

            let newFolder = Pastas(context: self.context)
            textfield.placeholder = "Nome"
            newFolder.titulo = textfield.text
            
            do{
                try self.context.save()
            }
            catch{
                    
            }
            
            self.fetchFolder()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let pasta = self.data![indexPath.row]
        
        cell.textLabel?.text = pasta.titulo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(identifier: "SecondVC") as! SecondViewController
//
//        show(vc, sender: self)\
        let folder = self.data![indexPath.row]
        
        let alert = UIAlertController(title: "Teste", message: "Tô testando garai", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = folder.titulo
        
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel)
        let saveButton = UIAlertAction(title: "Salvar", style: .default){ (action) in
            let textField = alert.textFields![0]
            
            folder.titulo = textField.text
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchFolder()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: ""){ (action, view, completionHandler) in
            let folderToRemove = self.data![indexPath.row]
            
            self.context.delete(folderToRemove)
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchFolder()
        }
        action.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
