/** Lightweight WDDX deserializer. Only subset of spec has been
    implemented.
  */
public with sharing class WDDXDeserializer {
    private Map<String, WDDXProcessor> myProcessors;
    private String myWddxString;
    private XmlStreamReader myReader;
    private Boolean processingStarted = false;
    
    public WDDXDeserializer(string wddxString ) {
        myWddxString = wddxString;
        initProcessors();
    }
        
    public WDDXData deserialize() {
        //System.debug(myWddxString);
        myReader = new XmlStreamReader(myWddxString);
        WDDXItem res;
        while(myReader.hasNext()) {
            if(myReader.getEventType() == XmlTag.START_ELEMENT) {
                if(!processingStarted) {
                    // make sure that this element is wddxPacket
                    if(myReader.getLocalName() != 'wddxPacket') {
                        //throw new WDDXDeserializeException('Invalid WDDX Packet. All packets must start with wddxPacket element'); commented MP on 2/25/2013
                        throw new WDDXDeserializeException('Services is down.'); //new line added with different message by MP as discussed in meeting
                    }
                    processingStarted = true;
                } else {
                    // try to find a processor for this guy, otherwise
                    // just continue
                    WDDXProcessor processor = myProcessors.get(myReader.getLocalName());
                    if(processor != null)
                        res = processor.execute();
                }
            }
            
            myReader.next();
        }
        
        // Should have received a data item here (which must be the first processor to go)
        return (WDDXData)res;
    }
    
    public WDDXProcessor getProcessor(string processorName) {
        //System.debug('---------------processorName---'+processorName);
        return myProcessors.get(processorName).create();
    }
    
    private XmlStreamReader getReader() {
        return myReader;
    }
    
    private void initProcessors() {
        myProcessors = new Map<String, WDDXProcessor> {
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
    
    // HELPER CLASSES /////////////////////////////////////////////////
    private class DataProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        private WDDXData myRetData;
        
        public WDDXProcessor create() {
            return new DataProcessor(myDeserializer);
        }
        
        public DataProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
            myRetData = new WDDXData();
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.START_ELEMENT) {
                    WDDXProcessor proc = myDeserializer.getProcessor(reader.getLocalName());
                    if(proc != null) {
                        myRetData.items.add(proc.execute());
                    }
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    if(reader.getLocalName() == 'data') {
                        break;
                    }
                }
                
                reader.next();
            }
            
            return myRetData;
        }
    }
    
    private class StructProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        private WDDXStruct myRetStruct;
        
        public WDDXProcessor create() {
            return new StructProcessor(myDeserializer);
        }
        
        public StructProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
            myRetStruct = new WDDXStruct();
            
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.START_ELEMENT) {
                    WDDXProcessor proc = myDeserializer.getProcessor(reader.getLocalName());
                    if(proc != null) {
                        WDDXVariable var = (WDDXVariable)proc.execute();
                        myRetStruct.put(var);
                    }
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    if(reader.getLocalName() == 'struct') {
                        break;
                    }
                }
                
                reader.next();
            }
            
            return myRetStruct;
        }
    }
    
    private class ArrayProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        private WDDXArray myRetArr;
        
        public WDDXProcessor create() {
            return new ArrayProcessor(myDeserializer);
        }
        
        public ArrayProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
            myRetArr = new WDDXArray();
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.START_ELEMENT) {
                    WDDXProcessor proc = myDeserializer.getProcessor(reader.getLocalName());
                    if(proc != null) {
                        myRetArr.items.add(proc.execute());
                    }
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    if(reader.getLocalName() == 'array') {
                        break;
                    }
                } 
                
                reader.next();
            }
            
            return myRetArr;
        }
    }
    
    private class VariableProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        private WDDXVariable myVariable;
        
        
        public WDDXProcessor create() {
            return new VariableProcessor(myDeserializer);
        }
        
        public VariableProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
            myVariable = new WDDXVariable();
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            
            // get the identifer for this variable before continuing
            myVariable.identifier = reader.getAttributeValue(null, 'name');
            reader.next();
            //System.debug('---------myVariable.identifier------------'+myVariable.identifier);
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.START_ELEMENT) {
                    if(myVariable.identifier == null || myVariable.identifier == '') {
                        throw new WDDXDeserializeException('All WDDX var\'s must have a name');
                    }
                    WDDXProcessor proc = myDeserializer.getProcessor(reader.getLocalName());
                    if(proc != null) {
                        myVariable.item = proc.execute();
                    }
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    if(reader.getLocalName() == 'var') {
                        break;
                    }
                } 
                
                reader.next();
            }
            
            return myVariable;
        }
    }
    
    private class StringProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        
        public WDDXProcessor create() {
            return new StringProcessor(myDeserializer);
        }
        
        public StringProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            
            String res = '';
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.CHARACTERS) {
                    res += reader.getText();
                } else if(reader.getEventType() == XmlTag.ENTITY_REFERENCE) {
                    res += reader.getText();
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    break;
                } 
                
                reader.next();
            }
            
            return new WDDXString(res);
        }
    }
    
    private class NumberProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        
        
        public WDDXProcessor create() {
            return new NumberProcessor(myDeserializer);
        }
        
        public NumberProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            
            Double res = 0.0;
            
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.CHARACTERS) {
                    res = Double.valueOf(reader.getText());
                } else if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    break;
                } 
                
                reader.next();
            }
            
            return new WDDXNumber(res);
        }
    }
    
    private class NullProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        
        public WDDXProcessor create() {
            return this; // no reason to create anoter null processor
        }
        
        public NullProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
            reader.next();
            
            while(reader.hasNext()) {
                if(reader.getEventType() == XmlTag.END_ELEMENT) {
                    break;
                }
            }
            
            return WDDXNull.NIL;
        }
    }
    
    
  // added by dileep on march/11/14 to make supportable the parser for boolean tag 'Done for Usage type'  
  private class BooleanProcessor implements WDDXProcessor {
        private WDDXDeserializer myDeserializer;
        public WDDXProcessor create() {
            return new BooleanProcessor(myDeserializer);
        }
        
        public BooleanProcessor(WDDXDeserializer deserializer) {
            myDeserializer = deserializer;
        }
        
        public WDDXItem execute() {
            XmlStreamReader reader = myDeserializer.getReader();
             // get the identifer for this variable before continuing
            String boolVal= reader.getAttributeValue(null, 'value');
            return new WDDXBoolean(boolVal);
        }
    }
    
    
}