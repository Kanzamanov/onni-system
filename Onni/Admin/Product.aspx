<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="Onni.Admin.Product" %>

<%@ Import Namespace="Onni" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%= lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pcoded-inner-content pt-0">
        <div class="align-align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                </div>
                                <div class="card-block">
                                    <div class="row">

                                        <div class="col-sm-6 col-md-4 col-lg-4">
                                            <h4 class="sub-title">Товары</h4>
                                            <div>
                                                <div class="form-group">
                                                    <label>Название</label>
                                                    <div>
                                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                                            placeholder="Введите название товара">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                            ErrorMessage="Введите название" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtName">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                                        <asp:HiddenField ID="hdnMode" runat="server" Value="NORMAL" />

                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Описание</label>
                                                    <div>
                                                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                                                            placeholder="Введите описание товара" TextMode="Multiline">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                            ErrorMessage="Введите описание" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtDescription">
                                                        </asp:RequiredFieldValidator>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Цена</label>
                                                    <div>
                                                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"
                                                            placeholder="Введите цену товара">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                            ErrorMessage="Введите цену" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtPrice">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                                            ErrorMessage="Цена должна быть числом" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtPrice"
                                                            ValidationExpression="^\d{1,8}([.,]\d{1,4})?$">
                                                        </asp:RegularExpressionValidator>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Количество</label>
                                                    <div>
                                                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control"
                                                            placeholder="Введите количество товара">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                            ErrorMessage="Введите количество" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtQuantity">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                                            ErrorMessage="Количество должно быть положительным числом" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="txtQuantity"
                                                            ValidationExpression="^\d+$">
                                                        </asp:RegularExpressionValidator>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Срок годности</label>
                                                    <asp:TextBox ID="txtExpirationDate" runat="server" CssClass="form-control" TextMode="Date" />
                                                </div>

                                                <div class="form-group">
                                                    <label>Изображение</label>
                                                    <div>
                                                        <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control"
                                                            onchange="ImagePreview(this);" />
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Категория</label>
                                                    <div>
                                                        <asp:DropDownList ID="ddlCategories" runat="server" CssClass="form-control"
                                                            DataSourceID="SqlDataSource1" DataTextField="Name" DataValueField="CategoryId"
                                                            AppendDataBoundItems="true">
                                                            <asp:ListItem Value="0">Выберите категорию</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                            ErrorMessage="Выберите категорию" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="ddlCategories" InitialValue="0">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:cs %>"
                                                            SelectCommand="SELECT CategoryId, Name FROM Categories WHERE IsActive = 1"></asp:SqlDataSource>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label>Бренд</label>
                                                    <div>
                                                        <asp:DropDownList ID="ddlBrands" runat="server" CssClass="form-control"
                                                            DataSourceID="SqlDataSource2" DataTextField="Name" DataValueField="BrandId"
                                                            AppendDataBoundItems="true">
                                                            <asp:ListItem Value="0">Выберите бренд</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                                            ErrorMessage="Выберите бренд" ForeColor="Red" Display="Dynamic"
                                                            SetFocusOnError="true" ControlToValidate="ddlBrands" InitialValue="0">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:cs %>"
                                                            SelectCommand="SELECT BrandId, Name FROM Brands WHERE IsActive = 1"></asp:SqlDataSource>
                                                    </div>
                                                </div>

                                                <div class="form-check pl-4">
                                                    <asp:CheckBox ID="cbIsActive" runat="server" Text="&nbsp; Активен"
                                                        CssClass="form-check-input" />
                                                </div>

                                                <div class="pb-5">
                                                    <asp:Button ID="btnAddOrUpdate" runat="server" Text="Добавить" CssClass="btn btn-primary"
                                                        OnClick="btnAddOrUpdate_Click" />
                                                    &nbsp;
                                                <asp:Button ID="btnClear" runat="server" Text="Очистить" CssClass="btn btn-primary"
                                                    CausesValidation="false" OnClick="btnClear_Click" />
                                                </div>

                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-md-8 col-lg-8 mobile-inputs">
                                            <h4 class="sub-title">Список Товаров</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rProduct" runat="server" OnItemCommand="rProduct_ItemCommand"
                                                        OnItemDataBound="rProduct_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">Название:</th>
                                                                        <th>Изо-ние:</th>
                                                                        <th>Цена:</th>
                                                                        <th>Кол-во:</th>
                                                                        <th>Срок годности:</th>
                                                                        <th>Категория:</th>
                                                                        <th>Бренд:</th>
                                                                        <th>Статус:</th>
                                                                        <th>Описание:</th>
                                                                        <th>Дата создания:</th>
                                                                        <th class="datatable-nosort">Действия:</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td title='<%# Eval("Name") %>'><%# Truncate(Eval("Name"), 15) %></td>

                                                                <td>
                                                                    <img alt="" width="40" src="<%# Utils.GetImageUrl( Eval("ImageUrl")) %>" />
                                                                </td>

                                                                <td><%# string.Format("{0:0.##}", Eval("Price")) %> сом</td>

                                                                <td>
                                                                    <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity") %>'>
                                                                    </asp:Label>
                                                                </td>

                                                                <td>
                                                                    <asp:Label ID="lblExpirationDate" runat="server" Text='<%# Eval("ExpirationDate", "{0:dd-MM-yyyy}") %>'></asp:Label>
                                                                </td>

                                                                <td><%# Eval("CategoryName") %></td>

                                                                <td><%# Eval("BrandName") %></td>

                                                                <td>
                                                                    <asp:Label ID="lblIsActive" runat="server" Text='<%# Eval("IsActive") %>'>
                                                                    </asp:Label>
                                                                </td>

                                                                <td><%# Truncate(Eval("Description"), 50) %></td>

                                                                <td><%# Eval("CreatedDate") %></td>

                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server" CssClass="badge badge-primary"
                                                                        CommandName="edit" CommandArgument='<%# Eval("ProductId") %>' CausesValidation="false"
                                                                        ToolTip="Редактировать товар"><i class="fas fa-pen"></i>
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server" CssClass="badge bg-danger"
                                                                        CommandName="delete" CommandArgument='<%# Eval("ProductId") %>'
                                                                        OnClientClick="return confirm('Вы уверены, что хотите удалить этот товар?');"
                                                                        CausesValidation="false" ToolTip="Удалить товар"><i class="fas fa-trash"></i>
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton ID="lnkSell" runat="server" CssClass="badge badge-info"
                                                                        CommandName="sell" CommandArgument='<%# Eval("ProductId") %>' CausesValidation="false"
                                                                        ToolTip="Продать товар"><i class="fas fa-cash-register"></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                        </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
