PROJECT = "matriz"
PRODUCTION = "/var/www/pkgs/matriz"
DEMO = "/var/www/demo/programs"
OUT = "matriz.sh"

node {
   stage('Compress') {
      sh "git archive --format=tar -v -o ${PROJECT}.tar.gz HEAD"
      sh "git archive --format=zip -v -o ${PROJECT}.zip HEAD"
   }
   stage('Sign') {
      sh "> sha256sums.txt"
      sh "sha256sum *.tar.gz *.zip > sha256sums.txt"
      withCredentials([string(credentialsId: 'gpgpass', variable: 'gpgpass')]) {
        sh "gpg --pinentry-mode loopback --passphrase ${gpgpass} --yes --detach-sign -a sha256sums.txt"
      }
   }
   stage('Copy') {
      sh "cp ${PROJECT}.tar.gz ${PROJECT}.zip sha256sums.txt ${PRODUCTION}"
      sh "cp ${OUT} ${DEMO}"
   }
}
