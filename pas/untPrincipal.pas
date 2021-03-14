unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Vcl.Imaging.pngimage;

type

  TProduto = class
    cdproduto: integer;
    nmeproduto: string;
    vlrvenda: Currency;
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function buscarPorCodigo(): Boolean;
  published
    { published declarations }
  end;

  TCliente = class
    cdcliente: integer;
    nmecliente, nmecidade, cduf: string;
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function buscarPorCodigo(): Boolean;
  published
    { published declarations }
  end;

  TPedidoItem = class
    cdproduto, qtdproduto: integer;
    vlrvenda, vlrtotal: Currency;
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  published
    { published declarations }
  end;

  TPedido = class
    cdpedido: integer;
    dtapedido: TDateTime;
    cliente: TCliente;
    vlrtotal: Currency;
    itens: array of TPedidoItem;
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    procedure buscarPorCodigo();
    procedure item(item: TPedidoItem);
    procedure gravar();
    procedure cancelar();
    procedure total();
  published
    { published declarations }
  end;

  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    btnNovoPedido: TSpeedButton;
    btnCancelPedido: TSpeedButton;
    Label1: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    mednme_cliente: TMaskEdit;
    mednme_cidade: TMaskEdit;
    Panel5: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    medcd_produto: TMaskEdit;
    medqtd_produto: TMaskEdit;
    medvlr_venda: TMaskEdit;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Label3: TLabel;
    medcd_cliente: TMaskEdit;
    FDConnection1: TFDConnection;
    MTItemsPedido: TFDMemTable;
    FDQuery1: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    MTItemsPedidocd_produto: TIntegerField;
    MTItemsPedidonme_produto: TStringField;
    MTItemsPedidovlr_venda: TFloatField;
    MTItemsPedidoqtd_produto: TIntegerField;
    MTItemsPedidovlr_total: TFloatField;
    dsItemsPedido: TDataSource;
    Image1: TImage;
    lblTotal: TLabel;
    lblTotalItens: TLabel;
    btnAddProduto: TBitBtn;
    btnGravarPedido: TSpeedButton;
    medcd_uf: TMaskEdit;
    mednme_produto: TMaskEdit;
    btnAbrirPedido: TSpeedButton;
    lblPedido: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MTItemsPedidoCalcFields(DataSet: TDataSet);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure medcd_clienteExit(Sender: TObject);
    procedure medvlr_vendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure medcd_produtoExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddProdutoClick(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAbrirPedidoClick(Sender: TObject);
    procedure btnCancelPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    cliente: TCliente;
    produto: TProduto;
    procedure totalPedido();
  end;

var
  frmPrincipal: TfrmPrincipal;
  boEditarProduto: Boolean;

const
  sFormatCurrency: String = '#,##0.00';

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnAddProdutoClick(Sender: TObject);
begin
  if (Trim(medcd_produto.Text) = '') then
  begin
    Application.MessageBox('Informe um produto', 'ATENÇÃO',
      MB_OK + MB_ICONWARNING);
    medcd_produto.SetFocus;
    exit;
  end;

  try
    with MTItemsPedido do
    begin
      if (boEditarProduto) then
        Edit
      else
        Append;
      MTItemsPedidocd_produto.Value := StrToIntDef(medcd_produto.Text, -1);
      MTItemsPedidonme_produto.Value := AnsiUpperCase(mednme_produto.Text);
      MTItemsPedidoqtd_produto.Value := StrToIntDef(medqtd_produto.Text, 1);
      MTItemsPedidovlr_venda.Value := StrToFloatDef(medvlr_venda.Text, 0);
      Post;
    end;
    boEditarProduto := False;
    medcd_produto.Clear;
    medcd_produto.Enabled := not boEditarProduto;
    mednme_produto.Clear;
    medqtd_produto.Clear;
    medvlr_venda.Clear;

    totalPedido;

    if (SetFocusedControl(medcd_uf)) then
      medcd_uf.SetFocus;
  except
    on E: Exception do
      Application.MessageBox(PChar('Erro ao lançar o produto: ' + E.Message),
        'ERRO', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmPrincipal.btnCancelPedidoClick(Sender: TObject);
var
  pedido: TPedido;
  cdpedido: integer;
begin
  cdpedido := StrToInt(InputBox('Informe um número de pedido',
    'Cancelar pedido', '0'));
  if (cdpedido > 0) then
  begin
    pedido := TPedido.Create;
    pedido.cdpedido := cdpedido;
    pedido.buscarPorCodigo();
    if (pedido.cdpedido > 0) then
    begin
      pedido.cancelar();
      Application.MessageBox('Pedido cancelado', 'SUCESSO',
        MB_OK + MB_ICONINFORMATION);
    end;
  end;
end;

procedure TfrmPrincipal.btnGravarPedidoClick(Sender: TObject);
var
  pedido: TPedido;
  pedidoItem: TPedidoItem;
  vlrtotal: Currency;
begin

  if (Trim(medcd_cliente.Text) = '') then
  begin
    Application.MessageBox('Informe um cliente', 'ATENÇÃO',
      MB_OK + MB_ICONWARNING);
    medcd_cliente.SetFocus;
    exit;
  end;

  if (MTItemsPedido.IsEmpty) then
  begin
    Application.MessageBox('Adicione produtos no pedido', 'ATENÇÃO',
      MB_OK + MB_ICONWARNING);
    medcd_produto.SetFocus;
    exit;
  end;

  try
    FDConnection1.StartTransaction;
    vlrtotal := 0;
    pedido := TPedido.Create;
    pedido.cliente := cliente;

    with MTItemsPedido do
    begin
      DisableControls;
      First;
      while not EOF do
      begin
        pedidoItem := TPedidoItem.Create;
        pedidoItem.cdproduto := MTItemsPedidocd_produto.Value;
        pedidoItem.qtdproduto := MTItemsPedidoqtd_produto.Value;
        pedidoItem.vlrvenda := MTItemsPedidovlr_venda.Value;
        pedidoItem.vlrtotal := MTItemsPedidovlr_total.Value;
        vlrtotal := vlrtotal + pedidoItem.vlrtotal;
        pedido.item(pedidoItem);
        Next;
      end;
      EnableControls;
    end;

    pedido.vlrtotal := vlrtotal;
    pedido.gravar();

    FDConnection1.Commit;

    Application.MessageBox(PChar('Pedido gravado com sucesso: ' +
      IntToStr(pedido.cdpedido)), 'SUCESSO', MB_OK + MB_ICONINFORMATION);

    btnNovoPedidoClick(Sender);
  except
    on E: Exception do
    begin
      FDConnection1.Rollback;
      Application.MessageBox(PChar('O pedido não foi gravado'), 'ERRO',
        MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TfrmPrincipal.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
    if (ActiveControl is TDBGrid) then
    begin
      if (MTItemsPedido.IsEmpty or DBGrid1.ReadOnly) then
        exit;

      if (dsItemsPedido.State = dsBrowse) and (not MTItemsPedido.IsEmpty) then
        if Application.MessageBox('Confirma exclusão deste item?',
          'CONFIRMAÇÃO', MB_YESNO + MB_ICONQUESTION) = mrYes then
        begin
          MTItemsPedido.Delete;
          if (MTItemsPedido.IsEmpty) then
            medcd_produto.SetFocus;
        end;
    end;
end;

procedure TfrmPrincipal.btnAbrirPedidoClick(Sender: TObject);
var
  cdpedido: integer;
  pedido: TPedido;
  item: TPedidoItem;
begin
  btnNovoPedidoClick(Sender);
  cdpedido := StrToInt(InputBox('Informe um número de pedido',
    'Abrir pedido', '0'));
  if (cdpedido > 0) then
  begin
    pedido := TPedido.Create;
    pedido.cdpedido := cdpedido;
    pedido.buscarPorCodigo();
    lblPedido.Caption := 'Pedido ' + IntToStr(pedido.cdpedido) + ' - ' +
      FormatDateTime('dd/mm/yyyy hh:nn:ss', pedido.dtapedido);
    lblPedido.Visible := True;
    medcd_cliente.Text := IntToStr(pedido.cliente.cdcliente);
    mednme_cliente.Text := pedido.cliente.nmecliente;
    mednme_cidade.Text := pedido.cliente.nmecidade;
    medcd_uf.Text := pedido.cliente.cduf;
    for item in pedido.itens do
    begin
      medcd_produto.Text := IntToStr(item.cdproduto);
      medqtd_produto.Text := IntToStr(item.qtdproduto);
      medvlr_venda.Text := CurrToStrF(item.vlrvenda, ffCurrency, 2);

      medcd_produtoExit(Sender);
      btnAddProdutoClick(Sender);
    end;
    medcd_produto.Clear;
    mednme_produto.Clear;
    medqtd_produto.Clear;
    medvlr_venda.Clear;
    btnGravarPedido.Enabled := False;
    btnAddProduto.Enabled := False;
    DBGrid1.ReadOnly := True;
  end;
end;

procedure TfrmPrincipal.btnNovoPedidoClick(Sender: TObject);
begin
  medcd_cliente.Clear;
  mednme_cliente.Clear;
  mednme_cidade.Clear;
  medcd_uf.Clear;

  medcd_produto.Clear;
  mednme_produto.Clear;
  medqtd_produto.Clear;
  medvlr_venda.Clear;

  MTItemsPedido.Close;
  MTItemsPedido.Open;

  lblTotal.Caption := 'R$ 0,00';
  lblTotalItens.Caption := '0 itens';
  lblPedido.Visible := False;

  btnAbrirPedido.Enabled := True;
  btnCancelPedido.Enabled := True;

  btnGravarPedido.Enabled := True;
  btnAddProduto.Enabled := True;

  DBGrid1.ReadOnly := False;

  medcd_cliente.SetFocus;

  boEditarProduto := False;
end;

procedure TfrmPrincipal.Edit1DblClick(Sender: TObject);
begin
  totalPedido();
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FDPhysMySQLDriverLink1.VendorHome := ExtractFilePath(Application.ExeName);
  FDPhysMySQLDriverLink1.VendorLib := 'libmysql.dll';
  with FDConnection1.Params do
  begin
    Database := 'dbwktecnology';
    Password := 'homolog';
    UserName := 'root';
  end;
  FDConnection1.Connected := True;
  // Super dica do canal Embarcadero Brasil, performance no MemoryTable
  with MTItemsPedido do
  begin
    LogChanges := False;
    ResourceOptions.SilentMode := True;
    UpdateOptions.LockMode := lmNone;
    UpdateOptions.LockPoint := lpDeferred;
    UpdateOptions.FetchGeneratorsPoint := gpImmediate;
    Open;
  end;
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      begin
        if ((not(ActiveControl is TDBGrid)) and (not MTItemsPedido.IsEmpty))
        then
          DBGrid1.SetFocus;
      end;
  end;
end;

procedure TfrmPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then // ENTER
    if (not(ActiveControl is TDBGrid)) and (not(ActiveControl is TButton)) then
    begin
      Key := #0;
      SelectNext(ActiveControl, True, True);
    end
    else if (ActiveControl is TDBGrid) then
    begin
      if (MTItemsPedido.IsEmpty or DBGrid1.ReadOnly) then
        exit;

      if (dsItemsPedido.State = dsBrowse) and (not MTItemsPedido.IsEmpty) then
      begin
        boEditarProduto := True;
        medcd_produto.Enabled := not boEditarProduto;
        medcd_produto.Text := MTItemsPedidocd_produto.AsString;
        mednme_produto.Text := MTItemsPedidonme_produto.AsString;
        medqtd_produto.Text := MTItemsPedidoqtd_produto.AsString;
        medvlr_venda.Text := FormatCurr(sFormatCurrency,
          MTItemsPedidovlr_venda.Value);
        if SetFocusedControl(medqtd_produto) then
          medqtd_produto.SetFocus;
      end;
    end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  cliente := TCliente.Create;
  produto := TProduto.Create;
  btnNovoPedidoClick(Sender);
end;

procedure TfrmPrincipal.medcd_clienteExit(Sender: TObject);
begin
  if (Trim(medcd_cliente.Text) = '') then
    exit;

  cliente.cdcliente := StrToIntDef(medcd_cliente.Text, 0);
  cliente.buscarPorCodigo();
  mednme_cliente.Text := cliente.nmecliente;
  mednme_cidade.Text := cliente.nmecidade;
  medcd_uf.Text := cliente.cduf;

  btnAbrirPedido.Enabled := False;
  btnCancelPedido.Enabled := False;
end;

procedure TfrmPrincipal.medcd_produtoExit(Sender: TObject);
begin
  if (Trim(medcd_produto.Text) = '') then
    exit;

  produto.cdproduto := StrToIntDef(medcd_produto.Text, 0);
  produto.buscarPorCodigo();
  mednme_produto.Text := produto.nmeproduto;
  medqtd_produto.Text := '1';
  medvlr_venda.Text := FormatCurr(sFormatCurrency, produto.vlrvenda);
end;

procedure TfrmPrincipal.medvlr_vendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnAddProdutoClick(btnAddProduto);
end;

procedure TfrmPrincipal.MTItemsPedidoCalcFields(DataSet: TDataSet);
begin
  MTItemsPedidovlr_total.Value := MTItemsPedidovlr_venda.Value *
    MTItemsPedidoqtd_produto.Value;
end;

procedure TfrmPrincipal.totalPedido;
var
  vlrtotal: Currency;
  qtdItens: integer;
begin
  vlrtotal := 0;
  qtdItens := 0;
  with MTItemsPedido do
  begin
    DisableControls;
    First;
    while not EOF do
    begin
      vlrtotal := vlrtotal + MTItemsPedidovlr_total.Value;
      qtdItens := qtdItens + MTItemsPedidoqtd_produto.Value;
      Next;
    end;
    lblTotal.Caption := 'R$ ' + FormatCurr(sFormatCurrency, vlrtotal);
    lblTotalItens.Caption := IntToStr(qtdItens) + ' itens';
    EnableControls;
  end;
end;

{ TProduto }

function TProduto.buscarPorCodigo(): Boolean;
begin
  Result := False;
  if (Self.cdproduto > 0) then
  begin
    with frmPrincipal, FDQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select cd_produto, nme_produto, vlr_venda from tbprodutos where cd_produto = '
        + IntToStr(Self.cdproduto));
      Prepare;
      Open;
      if (RecordCount > 0) then
      begin
        Self.nmeproduto := FieldByName('nme_produto').AsString;
        Self.vlrvenda := FieldByName('vlr_venda').AsFloat;
        Result := True;
      end;
    end;
  end;
end;

{ TCliente }

function TCliente.buscarPorCodigo(): Boolean;
begin
  Result := False;
  if (Self.cdcliente > 0) then
  begin
    with frmPrincipal, FDQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select cd_cliente, nme_cliente, nme_cidade, cd_uf from tbclientes where cd_cliente = '
        + IntToStr(Self.cdcliente));
      Prepare;
      Open;
      if (RecordCount > 0) then
      begin
        Self.nmecliente := FieldByName('nme_cliente').AsString;
        Self.nmecidade := FieldByName('nme_cidade').AsString;
        Self.cduf := FieldByName('cd_uf').AsString;
        Result := True;
      end;
    end;
  end;
end;

{ TPedido }

procedure TPedido.buscarPorCodigo;
var
  item: TPedidoItem;
  cliente: TCliente;
begin
  if (Self.cdpedido > 0) then
  begin
    with frmPrincipal, FDQuery1 do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select cd_pedido, cd_cliente, dta_pedido, vlr_total from tbpedidos where cd_pedido = '
        + IntToStr(Self.cdpedido));
      Prepare;
      Open;
      if not EOF then
      begin
        cliente := TCliente.Create;
        Self.dtapedido := FieldByName('dta_pedido').AsDateTime;
        Self.vlrtotal := FieldByName('vlr_total').AsCurrency;

        cliente.cdcliente := FieldByName('cd_cliente').AsInteger;
        cliente.buscarPorCodigo();
        Self.cliente := cliente;

        Close;
        SQL.Clear;
        SQL.Add('select cd_item, cd_pedido, cd_produto, qtd_produto, vlr_venda, vlr_total from tbpedidos_itens where cd_pedido = '
          + IntToStr(Self.cdpedido));
        Prepare;
        Open;
        while not EOF do
        begin
          item := TPedidoItem.Create;
          item.cdproduto := FieldByName('cd_produto').AsInteger;
          item.qtdproduto := FieldByName('qtd_produto').AsInteger;
          item.vlrvenda := FieldByName('vlr_venda').AsCurrency;
          item.vlrtotal := FieldByName('vlr_total').AsCurrency;
          Self.item(item);
          Next;
        end;
      end;
    end;
  end;
end;

procedure TPedido.cancelar;
begin
  if (Self.cdpedido > 0) then
  begin
    with frmPrincipal, FDQuery1 do
    begin
      // excluindo pedido...
      Close;
      SQL.Clear;
      SQL.Add('delete from tbpedidos where cd_pedido = ' +
        IntToStr(Self.cdpedido));
      Prepare;
      ExecSQL;
    end;
  end;
end;

procedure TPedido.gravar;
var
  i: integer;
  item: TPedidoItem;
begin
  if ((Self.cliente.cdcliente > 0) and (Length(Self.itens) > 0)) then
  begin
    with frmPrincipal, FDQuery1 do
    begin
      // retornando data do pedido com horario do servidor...
      Close;
      SQL.Clear;
      SQL.Add('select current_timestamp as dta_pedido');
      Prepare;
      Open;
      Self.dtapedido := FieldByName('dta_pedido').AsDateTime;

      // inserindo pedido...
      Close;
      SQL.Clear;
      SQL.Add('insert into tbpedidos (dta_pedido, cd_cliente, vlr_total)');
      SQL.Add('values(' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',
        Self.dtapedido)) + ',');
      SQL.Add(IntToStr(Self.cliente.cdcliente) + ',');
      SQL.Add(StringReplace(CurrToStrF(Self.vlrtotal, ffFixed, 2), ',', '.',
        [rfReplaceAll]) + ')');
      Prepare;
      ExecSQL;

      // retornando ultimo pedido gravado...
      Close;
      SQL.Clear;
      SQL.Add('select last_insert_id() as cd_pedido');
      Prepare;
      Open;
      Self.cdpedido := FieldByName('cd_pedido').AsInteger;

      // inserinto itens
      for i := 0 to Length(Self.itens) - 1 do
      begin
        item := Self.itens[i];
        Close;
        SQL.Clear;
        SQL.Add('insert into tbpedidos_itens (cd_pedido, cd_produto, qtd_produto, vlr_venda, vlr_total)');
        SQL.Add('values(' + IntToStr(Self.cdpedido) + ',');
        SQL.Add(IntToStr(item.cdproduto) + ',');
        SQL.Add(IntToStr(item.qtdproduto) + ',');
        SQL.Add(StringReplace(CurrToStrF(item.vlrvenda, ffFixed, 2), ',', '.',
          [rfReplaceAll]) + ',');
        SQL.Add(StringReplace(CurrToStrF(item.vlrtotal, ffFixed, 2), ',', '.',
          [rfReplaceAll]) + ')');
        Prepare;
        ExecSQL;
      end;
    end;
  end;
end;

procedure TPedido.item(item: TPedidoItem);
var
  i: integer;
begin
  SetLength(Self.itens, Length(Self.itens) + 1);
  Self.itens[High(Self.itens)] := item;
end;

procedure TPedido.total;
begin

end;

end.
