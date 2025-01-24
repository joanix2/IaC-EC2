### **2. Installer Terraform**

1. **Télécharger Terraform :**

   ```bash
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   ```

2. **Vérifier l’installation :**

   ```bash
   terraform --version
   ```

   Cela doit retourner une version, par exemple : `Terraform v1.x.x`.

3. **Initialiser Terraform :**

   ```bash
   terraform init
   ```

4. **Vérifier le plan d’exécution :**

   ```bash
   terraform plan
   ```

5. **Appliquer la configuration :**

   ```bash
   terraform apply
   ```

   Vous devrez confirmer en tapant `yes`.

6. **Vérifier l’état de l’infrastructure :**

   ```bash
   terraform show
   ```

7. **Nettoyer les ressources :**
   Pour éviter des coûts inutiles, détruisez les ressources quand elles ne sont plus nécessaires :
   ```bash
   terraform destroy
   ```