//
//  SecondViewController.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 13/08/21.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    public var pastas: Pastas?
    var complitionHendler: (() -> Void)?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var isTableEditMode: Bool = false{
        didSet{
            habilitarModoEdicao(isTableEditMode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchFolderArea() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Nova anotação", message: "Digite um título para esta anotação", preferredStyle: .alert)
        alert.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel)
        let submitButton = UIAlertAction(title: "Salvar", style: .default) { (action) in
            
            let textfield = alert.textFields![0]

            let newFolder = Anotacoes(context: self.context)
            textfield.placeholder = "Nome"
            newFolder.titulo = textfield.text
            
            self.pastas?.addToAnotacoes(newFolder)
            do{
                try self.context.save()
            }
            catch{
                    
            }
            
            self.fetchFolderArea()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func editTapped (_ sender: Any) {
        isTableEditMode = !isTableEditMode
    }
    
    func habilitarModoEdicao(_ condicao: Bool){
        tableView.setEditing(condicao, animated: true)
        let titulo = condicao ? "OK" : "Editar"
        let font = condicao ? UIFont.boldSystemFont(ofSize: 18.0) : UIFont.systemFont(ofSize: 18.0)
        editButton.setTitle(titulo, for: .normal)
        editButton.titleLabel?.font = font
    }
    
    func editItems (indexPath: IndexPath){
        let folder = self.pastas?.anotacoes?.array[indexPath.row] as! Anotacoes
        
        let alert = UIAlertController(title: "Renomear", message: "", preferredStyle: .alert)
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
            
            self.fetchFolderArea()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func accessoryEditButtonTapped(_ sender: CustomUIButton){
        self.editItems(indexPath: sender.indexPath!)
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastas?.anotacoes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let anotacao:Anotacoes
        
        anotacao = pastas?.anotacoes?.array[indexPath.row] as! Anotacoes
        
        cell.textLabel?.text = anotacao.titulo
        cell.imageView?.image = UIImage(systemName: "folder")
        
        let editButton = CustomUIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25), customButtonType: .edit)
        editButton.indexPath = indexPath
        editButton.addTarget(self, action: #selector(accessoryEditButtonTapped(_:)), for: .touchUpInside)
        cell.editingAccessoryView = editButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ThirdVC") as! ThirdViewController

        vc.anotacoes = pastas?.anotacoes?.array[indexPath.row] as? Anotacoes
        
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: ""){ (action, view, completionHandler) in
            _ = self.pastas?.anotacoes?.array[indexPath.row] as! Anotacoes
            
            self.pastas?.removeFromAnotacoes(at: indexPath.row)
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchFolderArea()
        }
        action.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
