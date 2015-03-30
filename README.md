# Defence Solicitor Service Rota
[![Code
Climate](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota)

This application receives content from
[ministryofjustice/defence-request-service-auth](https://github.com/ministryofjustice/defence-request-service)
to build solicitor rotas.

## Environment Variables

See `.example.env`. Add any new Env vars required to this file, setting
placeholder data for them.

## API documentation
Written using API Blueprint syntax: https://apiblueprint.org/ into apiary.apib

To generate a new HTML format locally run: ```bin/render_api```
(requires [aglio](https://github.com/danielgtaylor/aglio))

API docs accessible from /api.html