# Keycloak - Tutoriel

## Introduction

[Keycloak](https://www.keycloak.org/) est une solution open-source de gestion des identités et des accès (IAM) qui permet de centraliser l'authentification et l'autorisation des utilisateurs pour des applications et des services. Keycloak offre une gestion des utilisateurs, des rôles, des permissions et prend en charge des protocoles standard comme **OAuth 2.0**, **OpenID Connect**, et **SAML 2.0**.

Keycloak permet d'implémenter facilement des fonctionnalités telles que :
- **Single Sign-On (SSO)** : Une fois connecté, l'utilisateur peut accéder à plusieurs applications sans avoir à se reconnecter.
- **Fédération d'identité** : Intégration avec des systèmes externes (LDAP, Active Directory, etc.).
- **Authentification multi-facteurs (MFA)** : Sécurisation des connexions avec des facteurs supplémentaires (par exemple, un code envoyé par SMS).
- **Gestion des rôles et des permissions** : Contrôle précis des accès et des ressources pour chaque utilisateur.

---

## Flux d'authentification de Keycloak

Le flux d'authentification dans Keycloak repose sur des **jetons** qui permettent à l'utilisateur de s'authentifier et d'accéder aux ressources protégées. Voici un aperçu des étapes du flux d'authentification standard pour une application qui utilise Keycloak.

1. **Accès à l'application** : L'utilisateur tente d'accéder à une application protégée.
   
2. **Redirection vers Keycloak** : Si l'utilisateur n'est pas authentifié, l'application redirige l'utilisateur vers le serveur Keycloak.

3. **Authentification dans Keycloak** : L'utilisateur s'authentifie dans Keycloak en fournissant ses informations d'identification (nom d'utilisateur, mot de passe) ou via un fournisseur d'identité externe (par exemple, Google, Facebook).

4. **Autorisation** : Une fois l'utilisateur authentifié, Keycloak vérifie si l'utilisateur a les permissions nécessaires pour accéder à l'application ou aux ressources demandées.

5. **Retour vers l'application avec jetons** : Si l'utilisateur est autorisé, Keycloak renvoie un **jeton d'accès** (access token) et un **jeton d'identité** (ID token) à l'application.

6. **Accès aux ressources** : L'application utilise le jeton d'accès pour effectuer des appels sécurisés vers des API ou accéder à des ressources protégées.

---

## Les Concepts Clés dans Keycloak

### 1. **Realm**

Un **realm** dans Keycloak est un espace de gestion distinct dans lequel les utilisateurs, rôles, applications et configurations sont définis. Chaque realm est isolé des autres, ce qui permet de séparer les configurations, les utilisateurs et les rôles entre différentes applications ou environnements.

- **Exemple d'utilisation** : Vous pourriez avoir un **realm** pour votre environnement de développement et un autre pour votre environnement de production.
- **Contenu** : Un realm contient des utilisateurs, des rôles, des groupes, des clients et des configurations de sécurité.

### 2. **Client**

Un **client** dans Keycloak est une application ou un service qui utilise Keycloak pour l'authentification et l'autorisation des utilisateurs. Les clients peuvent être des applications web, des services REST API, des applications mobiles, etc.

- **Exemple d'utilisation** : Un client peut être une application web qui redirige les utilisateurs vers Keycloak pour se connecter et obtenir des jetons d'accès.
- **Types de clients** :
  - **Public Clients** : Ces clients (par exemple, une application web front-end ou mobile) ne peuvent pas garder leur secret en sécurité.
  - **Confidential Clients** : Ces clients (par exemple, une API backend) peuvent sécuriser leur client secret et obtenir des jetons d'accès de manière sécurisée.

### 3. **Jetons (Tokens)**

Keycloak utilise des **jetons** pour assurer l'authentification et l'autorisation. Les deux principaux types de jetons sont :
- **Access Token** : Un jeton d'accès (généralement au format JWT) utilisé pour accéder aux ressources protégées.
- **ID Token** : Un jeton d'identité contenant des informations sur l'utilisateur, comme son nom, son adresse e-mail, etc.

### 4. **Utilisateurs et Rôles**

Keycloak permet de définir des **utilisateurs** et de leur attribuer des **rôles**. Les rôles déterminent ce que les utilisateurs peuvent faire dans l'application, comme accéder à certaines ressources ou effectuer certaines actions.

- **Utilisateurs** : Les personnes qui interagissent avec l'application. Un utilisateur peut appartenir à un ou plusieurs rôles.
- **Rôles** : Les rôles sont utilisés pour définir les permissions d'un utilisateur. Par exemple, un rôle d'**administrateur** pourrait permettre de modifier les configurations, tandis qu'un rôle d'**utilisateur** accorde uniquement l'accès à certaines parties de l'application.

### 5. **Fédération d'identité**

La **fédération d'identité** permet à Keycloak d'intégrer d'autres systèmes d'identité pour gérer les utilisateurs. Par exemple, vous pouvez connecter Keycloak à un **LDAP** ou un **Active Directory** pour importer les utilisateurs et les groupes d'utilisateurs existants dans Keycloak.

- **Exemple d'utilisation** : Si vous avez une base d'utilisateurs dans LDAP ou Active Directory, vous pouvez configurer Keycloak pour les synchroniser.

### 6. **Single Sign-On (SSO)**

Le **Single Sign-On (SSO)** permet aux utilisateurs de se connecter une seule fois à un système d'authentification centralisé (Keycloak) et d'accéder à plusieurs applications sans avoir à se reconnecter.

- **Exemple d'utilisation** : Un utilisateur se connecte à une première application via Keycloak et peut ensuite accéder à d'autres applications protégées par Keycloak sans devoir se reconnecter.

### 7. **Authn et Authz (Authentication and Authorization)**

- **Authentication (Authn)** : Le processus de vérification de l'identité de l'utilisateur, généralement par l'authentification de son nom d'utilisateur et mot de passe.
- **Authorization (Authz)** : Le processus de vérification des permissions de l'utilisateur après l'authentification pour déterminer s'il a le droit d'accéder à une ressource spécifique.

---

## Conclusion

Keycloak est une solution puissante et flexible pour gérer l'authentification et l'autorisation dans des environnements complexes. Il vous permet de centraliser l'authentification, de gérer les utilisateurs et les rôles, de mettre en place le Single Sign-On, et d'intégrer d'autres systèmes d'identité externes. En comprenant les concepts de **realm**, **client**, **jetons**, et la façon dont Keycloak gère l'authentification et l'autorisation, vous pouvez facilement intégrer Keycloak dans vos applications et services.
