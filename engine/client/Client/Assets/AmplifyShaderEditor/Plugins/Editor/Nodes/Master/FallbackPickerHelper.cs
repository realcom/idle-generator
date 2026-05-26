using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;

namespace AmplifyShaderEditor
{
		[Serializable]
		public class FallbackPickerHelper : ScriptableObject
		{
			private const string FallbackFormat = "Fallback \"{0}\"";
			private const string FallbackShaderStr = "Fallback";

			[SerializeField]
			private string m_fallbackShader = string.Empty;

			public void Init()
			{
				hideFlags = HideFlags.HideAndDontSave;
			}

		public void Draw( ParentNode owner )
		{
			EditorGUILayout.BeginHorizontal();
			m_fallbackShader = owner.EditorGUILayoutTextField( FallbackShaderStr, m_fallbackShader );
			if ( GUILayout.Button( string.Empty, UIUtils.InspectorPopdropdownFallback, GUILayout.Width( 17 ), GUILayout.Height( 19 ) ) )
			{
				EditorGUI.FocusTextInControl( null );
				GUI.FocusControl( null );
				DisplayShaderContext( owner, GUILayoutUtility.GetRect( GUIContent.none, EditorStyles.popup ) );
			}
			EditorGUILayout.EndHorizontal();
		}

			private void DisplayShaderContext( ParentNode node, Rect r )
			{
				GenericMenu shaderMenu = BuildShaderMenu( m_fallbackShader, OnSelectedShaderPopup );
				shaderMenu.ShowAsContext();
			}

			private void OnSelectedShaderPopup( string shaderName )
			{
				if ( !string.IsNullOrEmpty( shaderName ) )
				{
					UIUtils.MarkUndoAction();
					Undo.RecordObject( this, "Selected fallback shader" );
					m_fallbackShader = shaderName;
				}
			}
		
		public void ReadFromString( ref uint index, ref string[] nodeParams )
		{
			m_fallbackShader = nodeParams[ index++ ];
		}

		public void WriteToString( ref string nodeInfo )
		{
			IOUtils.AddFieldValueToString( ref nodeInfo, m_fallbackShader );
		}

			public void Destroy()
			{
			}

		public string TabbedFallbackShader
		{
			get
			{
				if( string.IsNullOrEmpty( m_fallbackShader ) )
					return string.Empty;

				return "\t" + string.Format( FallbackFormat, m_fallbackShader ) + "\n";
			}
		}

		public string FallbackShader
		{
			get
			{
				if( string.IsNullOrEmpty( m_fallbackShader ) )
					return string.Empty;

				return string.Format( FallbackFormat, m_fallbackShader );
			}
		}

		public string RawFallbackShader
		{
			get
			{
				return m_fallbackShader;
			}
			set
			{
				m_fallbackShader = value;
			}
		}


			public bool Active { get { return !string.IsNullOrEmpty( m_fallbackShader ); } }

			private static GenericMenu BuildShaderMenu( string currentShaderName, Action<string> onSelectedShader )
			{
				GenericMenu menu = new GenericMenu();
				List<string> shaderNames = CollectShaderNames( currentShaderName );
				for ( int i = 0; i < shaderNames.Count; i++ )
				{
					string shaderName = shaderNames[ i ];
					menu.AddItem( new GUIContent( shaderName ),
						string.Equals( shaderName, currentShaderName, StringComparison.Ordinal ),
						() => onSelectedShader( shaderName ) );
				}

				if ( shaderNames.Count == 0 )
					menu.AddDisabledItem( new GUIContent( "No shaders found" ) );

				return menu;
			}

			private static List<string> CollectShaderNames( string currentShaderName )
			{
				SortedSet<string> shaderNames = new SortedSet<string>( StringComparer.Ordinal );
				AddShaderNamesFromShaderUtil( shaderNames, currentShaderName );
				AddShaderNamesFromAssetDatabase( shaderNames, currentShaderName );
				AddShaderNamesFromLoadedShaders( shaderNames, currentShaderName );
				return new List<string>( shaderNames );
			}

			private static void AddShaderNamesFromShaderUtil( SortedSet<string> shaderNames, string currentShaderName )
			{
				MethodInfo getAllShaderInfo = typeof( ShaderUtil ).GetMethod( "GetAllShaderInfo", BindingFlags.Public | BindingFlags.Static );
				if ( getAllShaderInfo == null )
					return;

				Array availableShaders = getAllShaderInfo.Invoke( null, null ) as Array;
				if ( availableShaders == null )
					return;

				foreach ( object shaderInfo in availableShaders )
				{
					AddShaderName( shaderNames, ExtractShaderInfoName( shaderInfo ), currentShaderName );
				}
			}

			private static void AddShaderNamesFromAssetDatabase( SortedSet<string> shaderNames, string currentShaderName )
			{
				string[] shaderGuids = AssetDatabase.FindAssets( "t:Shader" );
				for ( int i = 0; i < shaderGuids.Length; i++ )
				{
					string shaderPath = AssetDatabase.GUIDToAssetPath( shaderGuids[ i ] );
					Shader shader = AssetDatabase.LoadAssetAtPath<Shader>( shaderPath );
					if ( shader != null )
						AddShaderName( shaderNames, shader.name, currentShaderName );
				}
			}

			private static void AddShaderNamesFromLoadedShaders( SortedSet<string> shaderNames, string currentShaderName )
			{
				Shader[] loadedShaders = Resources.FindObjectsOfTypeAll<Shader>();
				for ( int i = 0; i < loadedShaders.Length; i++ )
				{
					if ( loadedShaders[ i ] != null )
						AddShaderName( shaderNames, loadedShaders[ i ].name, currentShaderName );
				}
			}

			private static string ExtractShaderInfoName( object shaderInfo )
			{
				if ( shaderInfo == null )
					return string.Empty;

				Type shaderInfoType = shaderInfo.GetType();
				FieldInfo nameField = shaderInfoType.GetField( "name", BindingFlags.Public | BindingFlags.Instance );
				if ( nameField != null )
					return nameField.GetValue( shaderInfo ) as string;

				PropertyInfo nameProperty = shaderInfoType.GetProperty( "name", BindingFlags.Public | BindingFlags.Instance );
				if ( nameProperty != null )
					return nameProperty.GetValue( shaderInfo, null ) as string;

				PropertyInfo upperNameProperty = shaderInfoType.GetProperty( "Name", BindingFlags.Public | BindingFlags.Instance );
				if ( upperNameProperty != null )
					return upperNameProperty.GetValue( shaderInfo, null ) as string;

				return string.Empty;
			}

			private static void AddShaderName( SortedSet<string> shaderNames, string shaderName, string currentShaderName )
			{
				if ( string.IsNullOrEmpty( shaderName ) )
					return;

				if ( shaderName.StartsWith( "Hidden/", StringComparison.Ordinal ) &&
					!string.Equals( shaderName, currentShaderName, StringComparison.Ordinal ) )
					return;

				shaderNames.Add( shaderName );
			}

		}
	}
