//
//  File.swift
//
//
//  Created by Marvin Liu on 10/27/22.
//

import Foundation

public class Timeline {
    internal let plugins: [PluginType: Mediator]


    init() {
        self.plugins = [
            PluginType.before: Mediator(),
            PluginType.enrichment: Mediator(),
            PluginType.destination: Mediator(),
            PluginType.utility: Mediator()
        ]
    }

    func process(event: BaseEvent) {
        let beforeResult = applyPlugin(pluginType: PluginType.before, event: event)
        let enrichmentResult = applyPlugin(pluginType: PluginType.enrichment, event: beforeResult)
        _ = applyPlugin(pluginType: PluginType.destination, event: enrichmentResult)

    }

    internal func applyPlugin(pluginType: PluginType, event: BaseEvent?) -> BaseEvent? {
        var result: BaseEvent? = event
        if let mediator = plugins[pluginType], let e = event {
            result = mediator.execute(event: e)
        }
        return result
        
    }
    
    internal func add(plugin: Plugin) {
        if let mediator = plugins[plugin.type] {
            mediator.add(plugin: plugin)
        }
    }

    internal func remove(plugin: Plugin) {
        // remove all plugins with this name in every category
        for _plugin in plugins {
            let list = _plugin.value
            list.remove(plugin: plugin)
        }
    }

    internal func applyClosure(_ closure: (Plugin) -> Void) {
        for plugin in plugins {
            let mediator = plugin.value
            mediator.applyClosure(closure)
        }
    }
}
