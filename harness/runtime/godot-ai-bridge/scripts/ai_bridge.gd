extends Node

signal completed(ok: bool, text: String, raw: Dictionary)

var endpoint := "http://127.0.0.1:11434/v1/chat/completions"
var model := "llama3.2"
var api_key := ""

var _request: HTTPRequest


func _ready() -> void:
	_request = HTTPRequest.new()
	add_child(_request)
	_request.request_completed.connect(_on_request_completed)


func ask(prompt: String, content_context: String) -> Error:
	if _request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		_request.cancel_request()

	var system_prompt := (
		"You are an assistant embedded in a Godot idle-RPG prototype. "
		+ "Use only the provided harness data when recommending content, IDs, maps, units, skills, or items. "
		+ "If data is missing, say what is missing instead of inventing IDs. "
		+ "Answer in concise Korean."
	)
	var payload := {
		"model": model,
		"stream": false,
		"temperature": 0.35,
		"messages": [
			{"role": "system", "content": system_prompt},
			{
				"role": "user",
				"content": "Harness data summary:\n%s\n\nUser request:\n%s" % [content_context, prompt]
			}
		]
	}

	var headers := PackedStringArray(["Content-Type: application/json"])
	if api_key.strip_edges() != "":
		headers.append("Authorization: Bearer %s" % api_key.strip_edges())

	return _request.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))


func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	var raw_text := body.get_string_from_utf8()

	if result != HTTPRequest.RESULT_SUCCESS:
		completed.emit(false, "HTTP request failed: %s" % error_string(result), {})
		return

	if response_code < 200 or response_code >= 300:
		completed.emit(false, "HTTP %d\n%s" % [response_code, raw_text], {})
		return

	var json := JSON.new()
	var parse_error := json.parse(raw_text)
	if parse_error != OK:
		completed.emit(
			false,
			"JSON parse failed at line %d: %s\n%s"
			% [json.get_error_line(), json.get_error_message(), raw_text],
			{}
		)
		return

	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		completed.emit(false, "Unexpected response:\n%s" % raw_text, {})
		return

	completed.emit(true, _extract_text(data), data)


func _extract_text(data: Dictionary) -> String:
	if data.has("choices") and typeof(data["choices"]) == TYPE_ARRAY and data["choices"].size() > 0:
		var first_choice = data["choices"][0]
		if typeof(first_choice) == TYPE_DICTIONARY:
			var message = first_choice.get("message", {})
			if typeof(message) == TYPE_DICTIONARY and message.has("content"):
				return str(message["content"])
			if first_choice.has("text"):
				return str(first_choice["text"])

	if data.has("message"):
		var message = data["message"]
		if typeof(message) == TYPE_DICTIONARY and message.has("content"):
			return str(message["content"])
		return str(message)

	if data.has("response"):
		return str(data["response"])

	return JSON.stringify(data, "\t")
