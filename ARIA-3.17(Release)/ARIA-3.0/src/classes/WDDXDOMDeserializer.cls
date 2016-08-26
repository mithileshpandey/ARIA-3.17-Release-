// Written by Rakesh Kedia
public with sharing class WDDXDOMDeserializer {
	private Map<String, WDDXDOMProcessor> myProcessors;
	private DOM.Document myWddxDocument = new DOM.Document();
	private Boolean processingStarted = false;
	public WDDXDOMDeserializer(DOM.Document doc) {
        initProcessors();
        myWddxDocument = doc;
    }
	public WDDXDOMDeserializer(DOM.Document doc, Set<String> remTagsHavingAttrInSet) {
        initProcessors();
        system.debug(LoggingLevel.INFO,'******BEFORE REMOVING****** :'+Limits.getHeapSize());//+'  '+doc.toXmlString()
        if(remTagsHavingAttrInSet.size()>0){
        	Dom.XMLNode rt = doc.getRootElement();
        	removeUnusedTagsFromXML(rt,remTagsHavingAttrInSet);
        }
        system.debug(LoggingLevel.INFO,'******AFTER REMOVING****** :'+Limits.getHeapSize()+ '  '+doc.toXmlString());//+ '  '+ doc.toXmlString()
        myWddxDocument = doc;
    }
    
    public WDDXData deserialize() {
     	Dom.XMLNode rt = myWddxDocument.getRootElement();
    	WDDXItem res;
		//System.debug(LoggingLevel.INFO,'-----'+rt.getName());
		for(Dom.XMLNode child : rt.getChildElements()) {
			//System.debug(LoggingLevel.INFO,'-------------'+child.getName());
		 	if(!processingStarted) {
                // make sure that this element is wddxPacket
                if(rt.getName() != 'wddxPacket') {
                    //throw new WDDXDeserializeException('Invalid WDDX Packet. All packets must start with wddxPacket element'); commented MP on 2/25/2013
                    throw new WDDXDeserializeException('Services is down.'); //new line added with different message by MP as discussed in meeting
                }
                processingStarted = true;
            } else {
                // try to find a processor for this guy, otherwise
                // just continue
                WDDXDOMProcessor processor = myProcessors.get(child.getName());
                if(processor != null)
                    res = processor.execute(child);
            }
		}
        // Should have received a data item here (which must be the first processor to go)
        return (WDDXData)res;
    }
    
    private void initProcessors() {
        myProcessors = new Map<String, WDDXDOMProcessor> {
            'data'   => new DataProcessor(this),
            'struct' => new StructProcessor(this),
            'array'  => new ArrayProcessor(this),
            'var'    => new VariableProcessor(this),
            'string' => new StringProcessor(this),
            'number' => new NumberProcessor(this),
            'null'   => new NullProcessor(this),
            'boolean' => new BooleanProcessor(this)
        };
    }
    
    public WDDXDOMProcessor getProcessor(string processorName) {
        //System.debug(LoggingLevel.INFO,'---------------processorName---'+processorName);
        return myProcessors.get(processorName).create();
    }
    // HELPER CLASSES ///////////////////////////////////////////////// For Data
    private class DataProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        private WDDXData myRetData;

        public WDDXDOMProcessor create() {
            return new DataProcessor(myDeserializer);
        }
        
        public DataProcessor(WDDXDOMDeserializer deserializer) {
        	 myDeserializer = deserializer;
             myRetData = new WDDXData();
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	//System.debug(LoggingLevel.INFO,'DATA------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild);
           	for(Dom.XMLNode child : nextChild.getChildElements()) {
				//System.debug(LoggingLevel.INFO,'-------------'+child.getName());
			   // System.debug(LoggingLevel.INFO,'-------------'+child.getText());
			    WDDXDOMProcessor proc = myDeserializer.getProcessor(child.getName());
			    if(proc != null) {
                   myRetData.items.add(proc.execute(child));
                }
           }  
           return myRetData;
        }
        
    }
    // HELPER CLASSES ///////////////////////////////////////////////// For Struct
    private class StructProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        private WDDXStruct myRetStruct;
        
        public WDDXDOMProcessor create() {
            return new StructProcessor(myDeserializer);
        }
        
        public StructProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
            myRetStruct = new WDDXStruct();
            
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
            //System.debug(LoggingLevel.INFO,'STRUCT------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild);
           	for(Dom.XMLNode child : nextChild.getChildElements()) {
				//System.debug(LoggingLevel.INFO,'-------------'+child.getName());
			    //System.debug(LoggingLevel.INFO,'-------------'+child.getText());
			    WDDXDOMProcessor proc = myDeserializer.getProcessor(child.getName());
			    if(proc != null) {
                   WDDXVariable var = (WDDXVariable)proc.execute(child);
                   myRetStruct.put(var);
                }
            }  
            return myRetStruct;
        }
    }
    // HELPER CLASSES ///////////////////////////////////////////////// For Array
    private class ArrayProcessor implements WDDXDOMProcessor {
    	private Dom.XMLNode nextChild;
        private WDDXDOMDeserializer myDeserializer;
        private WDDXArray myRetArr;
        
        public WDDXDOMProcessor create() {
            return new ArrayProcessor(myDeserializer);
        }
        
        public ArrayProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
            myRetArr = new WDDXArray();
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	//System.debug(LoggingLevel.INFO,'ARRAY------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild);
           	for(Dom.XMLNode child : nextChild.getChildElements()) {
				//System.debug(LoggingLevel.INFO,'-------------'+child.getName());
			    //System.debug(LoggingLevel.INFO,'-------------'+child.getText());
			    WDDXDOMProcessor proc = myDeserializer.getProcessor(child.getName());
			    if(proc != null) {
                    myRetArr.items.add(proc.execute(child));
                }
            }           
            return myRetArr;
        }
    }
    // HELPER CLASSES ///////////////////////////////////////////////// For Var
    private class VariableProcessor implements WDDXDOMProcessor {
    	private Dom.XMLNode nextChild;
        private WDDXDOMDeserializer myDeserializer;
        private WDDXVariable myVariable;
        
        public WDDXDOMProcessor create() {
            return new VariableProcessor(myDeserializer);
        }
        
        public VariableProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
            myVariable = new WDDXVariable();
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
           	//System.debug(LoggingLevel.INFO,'VAR------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild.getName()+'  '+nextChild.getAttributeValue('name',null));
            myVariable.identifier = nextChild.getAttributeValue('name',null);
    		if(myVariable.identifier == null || myVariable.identifier == '') {
                throw new WDDXDeserializeException('All WDDX var\'s must have a name');
            }
            for(Dom.XMLNode child : nextChild.getChildElements()) {
	            WDDXDOMProcessor proc = myDeserializer.getProcessor(child.getName());
	            if(proc != null) {
	                myVariable.item = proc.execute(child); 
	            }
            }
            return myVariable;
        }
    }
    // HELPER CLASSES ///////////////////////////////////////////////// For String
    private class StringProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        
        public WDDXDOMProcessor create() {
            return new StringProcessor(myDeserializer);
        }
        
        public StringProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	//System.debug(LoggingLevel.INFO,'STRING------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild.getText());
            String res = nextChild.getText();
            return new WDDXString(res);
        }
    }
    
    // HELPER CLASSES ///////////////////////////////////////////////// For Number
    private class NumberProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        
        public WDDXDOMProcessor create() {
            return new NumberProcessor(myDeserializer);
        }
        
        public NumberProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	//System.debug(LoggingLevel.INFO,'NUMBER------------->>>>22222>>>>>>>>>>>>>>>>>>'+nextChild.getText());
        	Double res = 0.0;
        	if(nextChild.getText()!=null){
        		res = Double.valueOf(nextChild.getText());
        	}
            return new WDDXNumber(res);
        }
    }
    
    // HELPER CLASSES ///////////////////////////////////////////////// For NULL
    private class NullProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        
        public WDDXDOMProcessor create() {
            return this; // no reason to create anoter null processor
        }
        
        public NullProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	//System.debug(LoggingLevel.INFO,'NULL------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild.getText());
            return WDDXNull.NIL;
        }
    } 
      
    // HELPER CLASSES ///////////////////////////////////////////////// For Boolean
    private class BooleanProcessor implements WDDXDOMProcessor {
        private WDDXDOMDeserializer myDeserializer;
        public WDDXDOMProcessor create() {
            return new BooleanProcessor(myDeserializer);
        }
        
        public BooleanProcessor(WDDXDOMDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute(Dom.XMLNode nextChild) {
        	// get the identifer for this variable before continuing
        	//System.debug(LoggingLevel.INFO,'BOOLEAN------------->>>>>>>>>>>>>>>>>>>>>>'+nextChild.getText());
            String boolVal= nextChild.getAttributeValue('value',null);
            return new WDDXBoolean(boolVal);
        }
    }
    
    private void removeUnusedTagsFromXML(Dom.XMLNode rt, Set<String> remTagsHavingAttrInSet){
    	for (Dom.XmlNode child : rt.getChildren()) {
            if (child.getAttribute('name', null)!=null && remTagsHavingAttrInSet.contains(child.getAttribute('name', null))) {
            	//System.debug(LoggingLevel.INFO,'@@@@@@@@@@@@@@@@@@@@@ CHILD ATTRBUTE NAME ------------->>>>>>>>>>>>>>>>>>>>>> '+child.getAttribute('name', null));
                child.getParent().removeChild(child);
                continue;
            }
            removeUnusedTagsFromXML(child,remTagsHavingAttrInSet);
        }
    }
     private void checkNRemove(Dom.XMLNode rt, Set<String> remTagsHavingAttrInSet){
     	
     }
}