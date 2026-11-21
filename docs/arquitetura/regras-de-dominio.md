# Regras de domínio (aplique só as que servem)

> Regras que não valem para todo projeto, mas que, quando valem, são inegociáveis.
> Para cada projeto, copie as aplicáveis para a seção "Regras inegociáveis" do `AGENTS.md`.

---

## Dinheiro — se o projeto lida com valores financeiros
- Valores sempre como **inteiro em centavos** (`totalCents`). Nunca float.
- Formatação ("R$ 129,90") só na exibição, numa função única.
- Registros financeiros não são apagados nem editados: correção é feita com lançamento de estorno.
- Toda operação que movimenta dinheiro tem teste e roda em transação.
- Juros, parcelas e arredondamentos seguem uma regra única, documentada e testada.

## Multi-tenant — se o sistema vai atender mais de uma empresa ou cliente
- Toda tabela de negócio tem `tenant_id`.
- Toda consulta filtra por `tenant_id`, de preferência garantido por camada central (ou Row Level Security no Postgres).
- Teste que prova que um tenant não enxerga dados de outro.

## Dados pessoais — se guarda nome, CPF, e-mail, telefone etc. (LGPD)
- Colete só o necessário e registre para que cada dado serve.
- Dados sensíveis criptografados em repouso. Nunca em logs.
- Ter como exportar e apagar os dados de uma pessoa quando ela pedir.

## Autenticação e permissões — se tem login
- Use biblioteca ou serviço consolidado. Nunca implemente criptografia de senha por conta própria.
- Permissão checada no backend em toda ação, nunca só escondendo botão na tela.
- Ações sensíveis ficam registradas (quem, o quê, quando).

## Datas e horários — se agenda, prazos ou relatórios por período importam
- Salve em UTC (`timestamptz`). Exiba no fuso `America/Sao_Paulo`.
- Datas sem horário (vencimento, aniversário) ficam como `date`, sem fuso.

## Fiscal — se emite nota fiscal (NFC-e, NF-e)
- Use uma API de emissão consolidada. Não implemente a comunicação com a SEFAZ do zero.
- Guarde o XML autorizado de toda nota.

## Offline — se precisa funcionar sem internet (balcão, campo)
- Defina o que funciona offline e como sincroniza depois. Registre num ADR.
- Toda operação feita offline tem um ID gerado no cliente, para não duplicar na sincronização.
