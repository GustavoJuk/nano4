//
//  ViewController.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 12/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var data: [Pastas]?
    var filteredItems: [Pastas] = []
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
        
        indicator.hidesWhenStopped = true
        
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
    
    func filterContentForSearchText(_ searchText: String, category: Pastas? = nil) {
        filteredItems = (data?.filter { (pasta: Pastas) -> Bool in
            return (pasta.titulo?.lowercased().contains(searchText.lowercased()))!
        })!
      
      tableView.reloadData()
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
    
    @objc func accessoryEditButtonTapped(_ sender: CustomUIButton){
        self.editItems(indexPath: sender.indexPath!)
    }
    
    @IBAction func toNotaScreen() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ThirdVC") as! ThirdViewController
        
        show(vc, sender: self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredItems.count
        }
        return self.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let pasta:Pastas
        if isFiltering {
            pasta = filteredItems[indexPath.row]
        }else{
            pasta = data![indexPath.row]
        }
        
        cell.textLabel?.text = pasta.titulo
        cell.imageView?.image = UIImage(systemName: "folder")
        
        let editButton = CustomUIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25), customButtonType: .edit)
        editButton.indexPath = indexPath
        editButton.addTarget(self, action: #selector(accessoryEditButtonTapped(_:)), for: .touchUpInside)
        cell.editingAccessoryView = editButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "SecondVC") as! SecondViewController

        if isFiltering {
            vc.pastas = filteredItems[indexPath.row]
        }else{
            vc.pastas = data![indexPath.row]
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

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
