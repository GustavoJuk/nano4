//
//  ThirdViewController.swift
//  nano4
//
//  Created by Gustavo Juk Ferreira Cruz on 16/08/21.
//

import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var anotacoes: Anotacoes?
    var nota: Notas?
    
    var complitionHandler: (() -> Void)?
    
    var placeholderLabel : UILabel!
    var placeholderLabelTitle : UILabel!
    
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var caixaTexto: UITextView!
    
    func SaveButton() {
        if  let countTitulo = self.titulo.text?.count, countTitulo > 0{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //Se nota for nullo entao criar, se nao só editar
            if nota == nil{
                nota = Notas(context: context)
                nota?.titulo = titulo.text
                nota?.texto = caixaTexto.text
                
                anotacoes!.addToNotas(nota!)
            }
            else{
                nota?.titulo = titulo.text
                nota?.texto = caixaTexto.text
            }
            do{
                try context.save()
            }
            catch{
                
            }
            
            complitionHandler?()
           // navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.SaveButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Configurar o conteudo da nota
        configNota()
        //MARK:caixaTexto
        caixaTexto.delegate = self
        //MARK:titulo
        titulo.delegate = self
    
    }
//MARK:Limites de letras
    func textField(_ titulo: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return self.textLimit(textoExistente: titulo.text, novoTexto: string, limit: 10)
    }

    func textView(_ caixaTexto: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.textLimit(textoExistente: caixaTexto.text, novoTexto: text, limit: 500)
    }
        
    private func textLimit(textoExistente: String?, novoTexto: String, limit: Int) -> Bool {
        let texto = textoExistente ?? ""
        let isAtLimit = texto.count + novoTexto.count <= limit
        return isAtLimit
    }
    
    //Metodo para setar a view com conteudo
    private func configNota(){
        guard let nota = self.nota else{
            return
        }
        self.titulo.text = nota.titulo
        self.caixaTexto.text = nota.texto
    }
}
