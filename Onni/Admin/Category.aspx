<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Onni.Admin.Category" %>

<%@ Import Namespace="Onni" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <script>
        /* For disappearing alert message */
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
                                            <h4 class="sub-title">Добавить или редактировать категорию</h4>
                                            <div>
                                                <div class="form-group">
                                                    <label>Название Категории</label>
                                                    <div>
                                                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                                            placeholder="Введите название категории" required></asp:TextBox>
                                                        <asp:HiddenField ID="hdnId" runat="server" Value="0" />
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
                                            <h4 class="sub-title">Список категорий</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rCategory" runat="server" OnItemCommand="rCategory_ItemCommand"
                                                        OnItemDataBound="rCategory_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">Название</th>
                                                                        <th>Статус</th>
                                                                        <th>Дата создания</th>
                                                                        <th class="datatable-nosort">Действия</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><%# Eval("Name") %></td>
                                                                <td>
                                                                    <asp:Label ID="lblIsActive" runat="server" Text='<%# Eval("IsActive") %>'></asp:Label>
                                                                </td>
                                                                <td><%# Eval("CreatedDate") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server"
                                                                        CssClass="badge badge-primary" ToolTip="Редактировать категорию"
                                                                        CommandArgument='<%# Eval("CategoryId") %>' CommandName="edit"
                                                                        CausesValidation="false"><i class="fas fa-pen"></i>
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton ID="lnkDelete" runat="server"
                                                                        CssClass="badge bg-danger" ToolTip="Удалить категорию"
                                                                        CommandArgument='<%# Eval("CategoryId") %>' CommandName="delete"
                                                                        OnClientClick="return confirm('Вы действительно хотите удалить эту категорию?');"
                                                                        CausesValidation="false"><i class="fas fa-trash"></i>
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
