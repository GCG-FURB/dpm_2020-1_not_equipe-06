import UIKit
import CoreData

class UsuarioController: UIViewController {
    
    @IBOutlet weak var tf_nome: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_senha: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bt_criaUsuario(_ sender: Any) {
        self.persistUsuario()
        let (nome,email,senha) = self.getUsuario()
        if !nome.isEmpty && !email.isEmpty && !senha.isEmpty {
            self.requestUsuario(nome: nome,email: email,senha: senha)
        }
    }
    
    func requestUsuario(nome: String, email: String, senha: String) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        //requisita web
        let url = URL(string: "http://localhost:3333/users")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //transforma global int em string
        let nome = String(nome)
        let email = String(email)
        let senha = String(senha)
        let postString = "{\"name\":\""+nome+"\",\"email\":\""+email+"\",\"password\":\""+senha+"\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //let returnData = String(data: data!, encoding: .utf8)
            if error != nil
            {
                print("Error")
            }
            else
            {
                if let content = data {
                    do
                    {
                        //mostra json
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(myJson)
                        let alert = UIAlertController(title: "Cria novo usuário e persistido locamente", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    catch
                    {
                        let alert = UIAlertController(title: "Não foi possivel criar um novo usuário", message: "Verifique sua conexão com a rede", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
            
        }
        task.resume()
    }
    
    func persistUsuario() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Usuario", in: context)
        let nnewEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        nnewEntity.setValue(tf_nome.text, forKey: "nome")
        nnewEntity.setValue(tf_email.text, forKey: "email")
        nnewEntity.setValue(tf_senha.text, forKey: "senha")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed")
        }
    }
    
    func getUsuario() -> (String, String, String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuario")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let nome = data.value(forKey: "nome") as! String
                let email = data.value(forKey: "email") as! String
                let senha = data.value(forKey: "senha") as! String
                
                return (nome: nome, email: email, senha: senha)
            }
        } catch {
            print("Failed")
        }
        return (nome: "", email: "", senha: "")
    }
    
}
