# 0005. Script de inicialização para projetos novos

- **Data:** 2026-11-21
- **Status:** aceito

## Contexto
Começar um projeto a partir do template exige passos fáceis de esquecer: ativar o hook de commits, apagar os guias dos perfis que não serão usados, apagar o histórico do próprio template (devlog, handoff), recomeçar README, STATUS e CHANGELOG e criar o ADR de perfil com o número certo. Feito à mão, cada projeto acaba diferente.

## Decisão
Vamos manter `scripts/init.sh`, um script Bash que:
1. pergunta o nome do projeto e os perfis (ou recebe `--name` e `--profiles`);
2. faz os passos acima e preenche a seção "Arquitetura" do AGENTS.md;
3. tem `--dry-run`, que mostra o que faria sem mudar nada (mesma regra do perfil Automação).

O script não cria código nem pastas de aplicação. A estrutura do perfil é criada depois, seguindo o guia, porque as versões e os geradores das ferramentas mudam rápido (`docs/referencia/versoes.md`).

## Alternativas consideradas
- **Só um checklist em `docs/guias/`:** não depende de nada, mas é fácil pular um passo. O checklist continua existindo (`como-iniciar-um-projeto.md`) para quem quiser fazer à mão.
- **Um template por perfil:** descartado no ADR 0001.
- **Script em Node ou Python:** exigiria uma das duas linguagens antes de saber o perfil. Bash já vem com o Git (Git Bash no Windows).

## Consequências
- No Windows, o script roda no Git Bash, que vem com o Git.
- Quem mudar a estrutura de pastas do template precisa atualizar o script.
- Depois de usado, o script pode ser apagado do projeto.
