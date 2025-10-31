import asyncdispatch, httpclient, json, strutils

var cookie: string = ""
const api = "https://emailmux.com/"

proc create_headers(): HttpHeaders =
  result = newHttpHeaders({
    "Connection": "keep-alive",
    "Host": "emailmux.com",
    "Content-Type": "application/json",
    "accept": "application/json, text/plain, */*"
  })
  if cookie != "":
    result["cookie"] = cookie

proc init_cookie(): Future[void] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.get(api)
    if response.headers.hasKey("set-cookie"):
      cookie = response.headers["set-cookie"]
  finally:
    client.close()

proc generate_email*(): Future[JsonNode] {.async.} =
  await init_cookie()
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let json = %*{"domains":["hotmail","gmail_plus","googlemail"]}
    let response = await client.post(api & "generate-email", body = $json)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc use_email*(email:string): Future[JsonNode] {.async.} =
  await init_cookie()
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.get(api & "use-email?email=" & email)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc previous_email*(): Future[JsonNode] {.async.} =
  await init_cookie()
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.get(api & "previous-email")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_messages*(email:string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.get(api & "emails?email=" & email)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
