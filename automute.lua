obs = obslua

local src_info = {}
src_info.id = "auto_muter"
src_info.type = obs.OBS_SOURCE_TYPE_INPUT
src_info.output_flags = obs.OBS_SOURCE_DO_NOT_DUPLICATE

src_info.create = function(settings, source)
    data = {
        target_source = "",
        mute_state = false
    }
	return data
end

src_info.update = function(data, settings)
    data.target_source = obs.obs_data_get_string(settings, "target_source")
    data.mute_state = obs.obs_data_get_bool(settings, "mute_state")
end

src_info.get_name = function()
	return "Automatic (Un)Muter"
end

src_info.get_properties = function(data)
    local props = obs.obs_properties_create()

    local p = obs.obs_properties_add_list(props, "target_source", "Target Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            local name = obs.obs_source_get_name(source);
			obs.obs_property_list_add_string(p, name, name)
        end
    end
    obs.source_list_release(sources)

    obs.obs_properties_add_bool(props, "mute_state", "Mute State")

	return props
end

src_info.activate = function(data)
    local target = obs.obs_get_source_by_name(data.target_source)
    if target ~= nil then
        obs.obs_source_set_muted(target, data.mute_state)
        obs.obs_source_release(target);
    end
end

function script_description()
	return [[
        Adds a source that mutes another source when it is activated<br />
        
        <pre>
ISC License

Copyright (c) 2021 Mathew Scheidler

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
        </pre>
    ]]
end

obs.obs_register_source(src_info)