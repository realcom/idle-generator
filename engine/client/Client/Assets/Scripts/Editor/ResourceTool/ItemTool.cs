using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Commons;
using Commons.Resources;
using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using UnityEditor;
using UnityEngine;

public class ItemTool : ResourceParseTool<ResourceItem>
{
    public override void PostRetrievalProcess()
    {
        
    }

    protected override void QueryResources()
    {
        var json = File.ReadAllText(Path.Combine("Assets/PatchResources", "Items.json"));
        var resources = Config.JsonParser.Parse<Commons.Resources.Resources>(json);
        var items = resources.Items;

        var queryResult = new StringBuilder();
        queryResult.AppendLine("Query Result:");
        foreach (var item in items)
        {
            if (item.Type is ResourceItem.Types.Type.Gacha or ResourceItem.Types.Type.Bundle)
            {
                queryResult.AppendLine($"item: {item.Id}, {item.ClientName}");
                queryResult.AppendLine($"{item.TargetItemDataIds.Count}");
            }
        }
        
        Debug.Log(queryResult);
    }
}