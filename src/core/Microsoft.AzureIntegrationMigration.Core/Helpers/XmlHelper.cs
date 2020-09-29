// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System.IO;
using System.Xml;
using System.Xml.Linq;

namespace Microsoft.AzureIntegrationMigration.Core.Helpers
{
	/// <summary>
	/// Helper class for XML-related operations
	/// </summary>
	public static class XmlHelper
	{
		/// <summary>
		/// Adds a namespace to the root element of the supplied <see cref="XDocument"/> instance.
		/// </summary>
		/// <param name="xdocument"><see cref="XDocument"/> instance to update.</param>
		/// <param name="prefix">Prefix of the namespace to add.</param>
		/// <param name="xmlNamespaceUri">Namespace to add.</param>
		/// <returns>Updated <see cref="XDocument"/> instance.</returns>
		public static XDocument AddNamespace(XDocument xdocument, string prefix, string xmlNamespaceUri)
		{
			if (xdocument?.Root == null || string.IsNullOrEmpty(prefix))
			{
				return xdocument;
			}
			XNamespace value = XNamespace.Get(xmlNamespaceUri);
			xdocument.Root.Add(new XAttribute(XNamespace.Xmlns + prefix, value));
			return xdocument;
		}

		/// <summary>
		/// Updates the qualified name of the root element in the supplied <see cref="XDocument"/> instance.
		/// </summary>
		/// <param name="xdocument"><see cref="XDocument"/> instance to update.</param>
		/// <param name="prefix">Prefix to use.</param>
		/// <returns>Updated <see cref="XDocument"/> instance.</returns>
		public static XDocument UpdateRootQualifiedName(XDocument xdocument, string prefix)
		{
			if (xdocument?.Root == null || string.IsNullOrEmpty(prefix))
			{
				return xdocument;
			}
			xdocument.Root.Name = xdocument.Root.GetNamespaceOfPrefix(prefix) + xdocument.Root.Name.ToString();
			return xdocument;
		}

		/// <summary>
		/// Converts the supplied <see cref="XDocument"/> instance into an <see cref="XmlDocument"/> instance.
		/// </summary>
		/// <param name="xdocument"><see cref="XDocument"/> instance to convert.</param>
		/// <returns>Converted <see cref="XmlDocument"/> instance.</returns>
		public static XmlDocument ToXmlDocument(XDocument xdocument)
		{
			XmlDocument xmlDocument = new XmlDocument();
			if (xdocument == null)
			{
				return null;
			}
			using (XmlReader reader = xdocument.CreateReader())
			{
				xmlDocument.Load(reader);
				return xmlDocument;
			}
		}

		/// <summary>
		/// Converts the supplied <see cref="XmlDocument"/> instance into an <see cref="XDocument"/> instance.
		/// </summary>
		/// <param name="xdocument"><see cref="XmlDocument"/> instance to convert.</param>
		/// <returns>Converted <see cref="XDocument"/> instance.</returns>
		public static XDocument ToXDocument(XmlDocument xmlDoc)
		{
			XDocument result = null;
			if (xmlDoc == null)
			{
				return result;
			}
			using (XmlNodeReader xmlNodeReader = new XmlNodeReader(xmlDoc))
			{
				xmlNodeReader.MoveToContent();
				return XDocument.Load(xmlNodeReader);
			}
		}

		/// <summary>
		/// Serializes the supplied <see cref="XDocument"/> instance to a <see cref="Stream"/> instance.
		/// </summary>
		/// <param name="xdocument"><see cref="XDocument"/> instance to serialize.</param>
		/// <returns><see cref="Stream"/> instance containing the serialized data.</returns>
		public static Stream ToStream(XDocument xdocument)
		{
			if (xdocument == null)
			{
				return null;
			}
			MemoryStream memoryStream = new MemoryStream();
			XmlWriterSettings xmlWriterSettings = new XmlWriterSettings();
			xmlWriterSettings.OmitXmlDeclaration = true;
			xmlWriterSettings.Indent = true;
			using (XmlWriter writer = XmlWriter.Create(memoryStream, xmlWriterSettings))
			{
				xdocument.WriteTo(writer);
			}
			memoryStream.Position = 0L;
			return memoryStream;
		}
	}
}
