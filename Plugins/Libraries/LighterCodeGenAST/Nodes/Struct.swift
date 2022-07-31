//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

/**
 * An AST node representing a Swift structure type.
 */
public struct Struct {

  /**
   * An instance variable of a ``Struct``.
   */
  public struct InstanceVariable: Equatable {
        
    /// Is the property public?
    public var `public` : Bool
    /// Is the property readonly.
    public var `let`    : Bool
    /// The name of the property.
    public var name     : String
    /// The type of the property, e.g. `.integer`, if it can't be derived from
    /// the ``value``. Either must be set.
    public var type     : TypeReference?
    /// The value of the property, if set.
    public var value    : Expression?
    /// A comment for the property.
    public var comment  : String?
    
    /// Initialize a new instance variable node.
    public init(public: Bool = true, `let`: Bool = true, _ name: String,
                type: TypeReference? = nil, value: Expression? = nil,
                comment: String? = nil)
    {
      self.public  = `public`
      self.let     = `let`
      self.name    = name
      self.type    = type
      self.value   = value
      self.comment = comment
    }
  }

  // MARK: - Header
  
  /// Whether the structure implements `@dynamicMemberLookup`.
  public var dynamicMemberLookup    = false
  /// Documentation for the structure.
  public var comment                : TypeComment?
  /// Whether the structure is public.
  public var `public`               : Bool
  /// The name of the structure.
  public var name                   : String
  /// The types the structure conforms to, e.g. `SQLTableRecord`.
  public var conformances           : [ TypeReference ]
  
  // MARK: - Types
  
  /// A set of type aliases that should be declare in the structure,
  /// e.g. `typealias RecordType = Person`.
  public var typeAliases            : [ ( name: String, type: TypeReference ) ]
  /// A set of structures nested in this structure.
  public var structures             : [ Struct ]

  // MARK: - Variables
  
  /// The type variables of the structure (i.e. `static let xyz` etc).
  public var typeVariables          : [ InstanceVariable ]
  /// The instance variables of the structure (i.e. `let xyz` etc).
  public var variables              : [ InstanceVariable ]
  
  // MARK: - Functions
  
  /// The computed type properties of the structure (i.e. `static var xyz` etc).
  public var computedTypeProperties : [ ComputedPropertyDefinition ]
  /// The computed properties of the structure (i.e. `var xyz : .. {}` etc).
  public var computedProperties     : [ ComputedPropertyDefinition ]
  /// The "type functions" of the structure (i.e. `static func xyz()`).
  public var typeFunctions          : [ FunctionDefinition ]
  /// The instance functions of the structure (i.e. `func xyz()`).
  public var functions              : [ FunctionDefinition ]

  
  /// Intialize a new struct AST node. Only the `name` is required.
  public init(dynamicMemberLookup    : Bool                           = false,
              public                 : Bool                           = true,
              name                   : String,
              conformances           : [ TypeReference ]              = [],
              typeAliases            : [ ( name: String, type: TypeReference ) ]
                                     = [],
              structures             : [ Struct ]                     = [],
              typeVariables          : [ InstanceVariable   ]         = [],
              variables              : [ InstanceVariable   ]         = [],
              computedTypeProperties : [ ComputedPropertyDefinition ] = [],
              computedProperties     : [ ComputedPropertyDefinition ] = [],
              typeFunctions          : [ FunctionDefinition ]         = [],
              functions              : [ FunctionDefinition ]         = [],
              comment                : TypeComment?                   = nil)
  {
    self.dynamicMemberLookup    = dynamicMemberLookup
    self.public                 = `public`
    self.name                   = name
    self.conformances           = conformances
    self.typeAliases            = typeAliases
    self.structures             = structures
    self.typeVariables          = typeVariables
    self.variables              = variables
    self.computedTypeProperties = computedTypeProperties
    self.computedProperties     = computedProperties
    self.typeFunctions          = typeFunctions
    self.functions              = functions
    self.comment                = comment
    
    // Note: We do not use a Dictionary to keep the sorting stable.
    assert(Set(typeAliases.map(\.name)).count == typeAliases.count,
           "Duplicate typealias names: \(typeAliases)")
  }
}


// MARK: - Convenience

public extension Struct.InstanceVariable {

  /// Initialize a new instance variable node for a `let`.
  static func `let`(public: Bool = true, _ name: String,
                    type: TypeReference? = nil,
                    is value: Expression,
                    comment: String? = nil)
              -> Self
  {
    .init(public: `public`, let: true, name, type: type, value: value,
          comment: comment)
  }

  /// Initialize a new instance variable node for a `let`.
  static func `let`(public: Bool = true, _ name: String, _ type: TypeReference,
                    comment: String? = nil)
              -> Self
  {
    .init(public: `public`, let: true, name, type: type, value: nil,
          comment: comment)
  }

  /// Initialize a new instance variable node for a `var`.
  static func `var`(public: Bool = true, _ name: String,
                    type: TypeReference? = nil,
                    is value: Expression,
                    comment: String? = nil)
              -> Self
  {
    .init(public: `public`, let: false, name, type: type, value: value,
          comment: comment)
  }
  
  /// Initialize a new instance variable node for a `var`.
  static func `var`(public: Bool = true, _ name: String, _ type: TypeReference,
                    comment: String? = nil)
              -> Self
  {
    .init(public: `public`, let: false, name, type: type, value: nil,
          comment: comment)
  }
}
