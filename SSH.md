## Récupérer ma clé SSH

cat ~/.ssh/id_rsa.pub

## Trouver le Security Group attaché à votre instance

aws ec2 describe-instances --instance-ids i-0b8866944fb1eef0d --query "Reservations[*].Instances[*].SecurityGroups" --output json

## Ajouter une règle pour autoriser SSH

aws ec2 authorize-security-group-ingress \
 --group-id <security-group-id> \
 --protocol tcp \
 --port 22 \
 --cidr 0.0.0.0/0

## connexion SSH

### donner les permision sur le fichier de la clé SSH

chmod 400 tfkey

### connexion ssh

ssh -i tfkey ec2-user@<PUBLIC_IP>
