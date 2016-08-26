public interface WDDXDOMProcessor {
    WDDXItem execute(Dom.XMLNode nextChild);
    WDDXDOMProcessor create();
}