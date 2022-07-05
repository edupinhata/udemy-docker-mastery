# README

## 78 class isntructions

- Let's use our Drupal compose file from last assignment (compose-assignment-2)
- Rename image back to official drupal:8.2
- Remove build
- Add secret via external
- use environemnt variable POSTGRES_PASSWORD_FILE
- Add secret via cli ```echo "<pw>" | docker secret create psql-pw -```
- Copy compose into a new yml file on your Swarm node1
