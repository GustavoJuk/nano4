//
//  SecondViewController.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 13/08/21.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    var pastas: Pastas?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var counter: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var data: [Anotacoes]?
    var filteredItems: [Anotacoes] = []
    private var isTableEditMode: Bool = false{
        didSet{
            habilitarModoEdicao(isTableEditMode)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
//        contador()
        
        fetchFolder()
    }
    
//    func contador() {
//        let pasta: Pastas
//        counter.text = "\(pasta.anotacoes?.count ?? 0) Notas"
//    }
    
    func fetchFolder () {
        
        do{
            self.data = try context.fetch(Anotacoes.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func filterContentForSearchText(_ searchText: String, category: Pastas? = nil) {
        filteredItems = (data?.filter { (pasta: Anotacoes) -> Bool in
            return (pasta.titulo?.lowercased().contains(searchText.lowercased()))!
        })!
      
      tableView.reloadData()
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
        let folder = self.data![indexPath.row]
        
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
            
            self.fetchFolder()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func accessoryEditButtonTapped(_ sender: CustomUIButton){
        self.editItems(indexPath: sender.indexPath!)
    }
    
    @IBAction func toNotaScreen() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ThirdVC") as! ThirdViewController
        
        show(vc, sender: self)
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredItems.count
        }
        return self.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let anotacao:Anotacoes
        if isFiltering {
            anotacao = filteredItems[indexPath.row]
        }else{
            anotacao = data![indexPath.row]
        }
        
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

        if isFiltering {
            vc.anotacoes = filteredItems[indexPath.row]
        }else{
            vc.anotacoes = data![indexPath.row]
        }
        
        show(vc, sender: self)
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

extension SecondViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
