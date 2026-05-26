using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Sirenix.OdinInspector;
using Sirenix.Serialization;
using UnityEngine;

public abstract class ClientDataRow
{
    public int Id;
}

public abstract class ResourceEntityClientDataContainer<ResourceRow> : ClientScriptableSingleton<ResourceEntityClientDataContainer<ResourceRow>> where ResourceRow : ClientDataRow
{
    [SerializeField, TableList] private List<ResourceRow> m_ClientDataRows = new();

    public IReadOnlyList<ResourceRow> ClientDataRows => m_ClientDataRows;
    
    private Dictionary<int, ResourceRow> m_ClientDataRowsById = new();
    
    protected override void OnLoaded()
    {
        m_ClientDataRowsById = m_ClientDataRows.ToDictionary(row => row.Id);
    }

    public ResourceRow Get(int Id) => m_ClientDataRowsById.GetValueOrDefault(Id);

}
